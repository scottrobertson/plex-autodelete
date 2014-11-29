require 'plex-ruby'

class Autodelete

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
      next if @config[:skip].include? show.title

      show.seasons.each do |season|
        season.episodes.each do |episode|
          if episode.respond_to?(:view_count)
            puts " - #{show.title} - #{season.title} - #{episode.title}"
            episode.medias.each do |media|
              media.parts.each do |part|
                if File.exist?(part.file) and @config[:delete]
                  File.delete(part.file)
                  puts "   - File Removed: #{part.file}"
                else
                  puts "   - File Not Removed: #{part.file}"
                end
              end
            end
            puts nil
          end
        end
      end
    end
  end
end


