require "plex/autodelete/version"
require "plex-ruby"

module Plex
  module Autodelete
    class Cleanup

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

      def self.required_params!
        [:host, :port, :token, :section].each do |param|
          if @config[param].nil?
            raise Exception
          end
        end
      end

      def self.cleanup

        self.required_params!

        Plex.configure do |config|
          config.auth_token = @config[:token]
        end

        server = Plex::Server.new(@config[:host], @config[:port])

        server.library.section(@config[:section]).all.each do |show|
          puts "#{show.title}".bold
          show.seasons.each do |season|
            puts " - #{season.title}"
            season.episodes.each do |episode|
              print "   - #{episode.title}"
              if episode.respond_to?(:view_count)
                episode.medias.each do |media|
                  media.parts.each do |part|
                    if @config[:delete] and not @config[:skip].include? show.title and File.exist?(part.file)
                      File.delete(part.file)
                      puts " (deleted)".yellow
                    else
                      if @config[:delete] or @config[:skip].include? show.title
                        puts " (skipped)".green
                      else
                        puts " (failed)".red
                      end
                    end
                  end
                end
              else
                if @config[:skip].include? show.title
                  puts ' (skipped)'.green
                else
                  puts ' (kept)'.blue
                end
              end
            end
          end
        end
      end
    end
  end
end
