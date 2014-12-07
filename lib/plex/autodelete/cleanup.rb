require "plex/autodelete/version"
require "plex-ruby"

module Plex
  module Autodelete
    class Cleanup

      @stats = {
        skipped: 0,
        deleted: 0,
        kept: 0,
        failed: 0,
      }

      @config = {
        host: '127.0.0.1',
        port: 32400,
        token: nil,
        skip: [],
        delete: true,
        section: 1,
      }

      @config_keys = @config.keys

      def self.configure(opts = {})
        opts.each {|key, value| @config[key.to_sym] = value if @config_keys.include? key.to_sym}
      end

      def self.cleanup
        self.required_params!
        self.plex_server.library.section(@config[:section]).all.each do |show|
          self.process_show show
        end

        self.output_stats
      end

      private

      def self.required_params!
        [:host, :port, :token, :section].each do |param|
          if @config[param].nil?
            raise Exception
          end
        end
      end

      def self.plex_server
        Plex.configure do |config|
          config.auth_token = @config[:token]
        end

        Plex::Server.new(@config[:host], @config[:port])
      end

      def self.process_show show
        puts nil
        puts "#{show.title}".bold
        show_skipped = @config[:skip].include? show.title
        show.seasons.each do |season|
          self.process_season season, show_skipped
        end
      end

      def self.process_season season, show_skipped
        puts " - #{season.title}"
        season.episodes.each do |episode|
          self.process_episode episode, show_skipped
        end
      end

      def self.process_episode episode, show_skipped
        print "   - #{episode.title} - "
        if self.should_delete_episode? episode, show_skipped
          episode.medias.each do |media|
            self.process_media media, show_skipped
          end
        else
          self.output_episode_skipped_reason episode, show_skipped
        end
      end

      def self.should_delete_episode? episode, show_skipped
        @config[:delete] and not show_skipped and episode_watched? episode
      end

      def self.output_episode_skipped_reason episode, show_skipped
        if episode_watched? episode and not @config[:delete]
          self.increment_stat :skipped
          puts 'Skipped (Test mode enabled, disable to perform delete)'.blue
        elsif episode_watched? episode and show_skipped
          self.increment_stat :skipped
          puts 'Skipped (Show in skip list)'.blue
        else
          self.increment_stat :kept
          puts 'Not watched yet'.blue
        end
      end

      def self.episode_watched? episode
        episode.respond_to?(:view_count) and episode.view_count.to_i > 0
      end

      def self.process_media media, show_skipped
        media.parts.each do |part|
          self.process_part part, show_skipped
        end
      end

      def self.process_part part, show_skipped
        if File.exist?(part.file)
          self.increment_stat :deleted
          File.delete(part.file)
          puts "Deleted".yellow
        else
          self.increment_stat :failed
          puts "File does not exist".red
        end
      end

      def self.increment_stat stat
        @stats[stat] += 1
      end

      def self.output_stats
        puts nil
        puts '-------------'
        puts '    Stats    '
        puts '-------------'
        puts "Deleted: #{@stats[:deleted].to_i}"
        puts "Skipped: #{@stats[:skipped].to_i}"
        puts "Kept:    #{@stats[:kept].to_i}"
        puts "Failed:  #{@stats[:failed].to_i}"
        puts nil
      end

    end
  end
end
