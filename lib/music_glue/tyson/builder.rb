require 'music_glue/tyson/middleware'
require 'music_glue/tyson/missing_authentication'
require 'rack/builder'
require 'warden'
require 'omniauth-music_glue'

class MusicGlue::Tyson::Builder

  def self.new(app, options = {})
    builder = ::Rack::Builder.new
    warden_stratagies   = options[:warden_stratagies] || [:tokens, :omniauth]
    warden_failure_app  = options[:failure_app]       || MusicGlue::Tyson::MussingAuthentication

    oauth_id, oauth_secret, oauth_options = extract_options!(options)
    unless options[:disabled]
      builder.use OmniAuth::Builder do
        provider :music_glue, oauth_id, oauth_secret, oauth_options
      end
      use Rack::Session::Cookie, :secret => "COOKIES"

      use Warden::Manager do |manager|
        manager.default_strategies warden_stratagies
        manager.failure_app = warden_failure_app

        Warden::Strategies.add :omniauth, MusicGlue::Tyson::Strategies::Omniauth

      end
    end
    builder.run MusicGlue::Tyson::Middleware.new(app, options)
    builder
  end

  def self.extract_options!(options)
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
