require 'music_glue/tyson/middleware'
require 'rack/builder'
require 'omniauth-music_glue'

module MusicGlue
  class Tyson::Builder

    def new(app, options = {})
      builder = Rack::Builder.new
      oauth_id, oauth_secret, oauth_scope = extract_options!(options)
      unless options[:disabled]
        builder.use OmniAuth::Builder do
          provider :music_glue, id, secret, oauth_options
        end
      end
      builder.run MusicGlue::Tyson::Middleware.new(app, options)
      builder
    end

    def extract_options!(options)
      oauth = options[:oauth] || {}
      oauth_options = options[:oauth_options] || {}
      id, secret = oauth[:id], oauth[:secret]

      if id.nil? || secret.nil? || id.empty? || secret.empty?
        $stderr.puts "[FATAL] music_glue-tyson disabled, missing variables"
        options[:disabled] = true
      end

      [id, secret, oauth_options]
    end

  end
end
