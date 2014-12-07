require "plex/autodelete/version"
require "plex-ruby"
require "yaml"

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

          puts nil
          puts "#{show.title}".bold

          show.seasons.each do |season|
            puts " - #{season.title}"
            season.episodes.each do |episode|
              print "   - #{episode.title} - "
              if episode.respond_to?(:view_count) and episode.view_count.to_i > 0
                if @config[:delete] and @config[:skip].include? show.title
                  episode.medias.each do |media|
                    media.parts.each do |part|
                      if File.exist?(part.file)
                        File.delete(part.file)
                        puts "Deleted".yellow
                      else
                        puts "File does not exist".red
                      end
                    end
                  end
                else
                  if @config[:skip].include? show.title
                    puts 'Skipped (Show in skip list)'.blue
                  else
                    puts 'Skipped (Test mode enabled, disable to perform delete)'.blue
                  end
                end
              else
                if @config[:skip].include? show.title
                  puts 'Skipped'.blue
                else
                  puts 'Not watched yet'.blue
                end
              end
            end
          end
        end
      end
    end
  end
end
