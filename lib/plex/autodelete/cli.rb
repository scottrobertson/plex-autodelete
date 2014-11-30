require 'thor'
require 'yaml'
require 'nori'
require 'colorize'
require 'plex/autodelete/cleanup'

module Plex
  module Autodelete

    class CLI < Thor

      @@config_file = ENV['HOME'] + '/.plex-autodelete.yml'
      @@config = nil
      @@myplex = {
        host: 'plex.tv',
        port: 443,
        path: '/users/sign_in.xml',
        client: "plex-autodelete #{Plex::Autodelete::VERSION}",
      }

      desc "cleanup", "Remove all watched episodes from Plex"
      def cleanup
        unless File.exists? @@config_file
          puts "Config file does not exist, please run 'plex-autocomplete install' to generate it".red
          exit
        end

        puts "#{config.to_yaml}\n"

        Plex::Autodelete::Cleanup.configure config
        Plex::Autodelete::Cleanup.cleanup
      end

      desc 'install', "Generate the config file to use with 'plex-autodelete cleanup'"
      def install

        puts "Generating token using https://#{@@myplex[:host]}. Username/Password will not be stored".bold
        username = ask("Username")
        password = ask("Password", echo: false)
        token = get_token(username, password)

        puts "\n"
        puts "Token generated: #{token}".green

        puts "\n"
        puts "Configure Plex Autodelete".bold

        @@config = {
          host: ask("Plex Server address", default: '127.0.0.1') ,
          port: ask("Plex Server port:", default: 32400),
          token: token,
          skip: ask("Shows to skip [comma seperated list]").split(','),
          delete: true,
          section: 1
        }

        write_config
        puts "Config file has been written to #{@@config_file}".green

      end

      private

      def write_config
        File.open(@@config_file, "w") { |file|
          YAML.dump(config, file)
        }
      end

      def config
        @@config ||= YAML::load_file(@@config_file)
      end

      def get_token(username, password)
        http = Net::HTTP.new(@@myplex[:host], @@myplex[:port])
        http.use_ssl = true
        http.start do |http|
          request = Net::HTTP::Post.new(@@myplex[:path], initheader = {'X-Plex-Client-Identifier' => @@myplex[:client]})
          request.basic_auth username, password
          response, data = http.request(request)

          parser = Nori.new
          hash = parser.parse(response.response.body)

          if hash.has_key?('errors')
            hash['errors'].each do |error|
              puts error.to_s.red
            end
            exit
          else
            hash['user']['authentication_token'].to_s
          end
        end
      end
    end
  end
end
