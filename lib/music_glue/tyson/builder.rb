require 'rack/builder'
require 'warden'
require 'rails_warden' if defined?('Rails')
require 'omniauth-music_glue'

require 'music_glue/tyson/middleware'
require 'music_glue/tyson/missing_authentication'

require 'music_glue/tyson/strategies/omniauth'

class MusicGlue::Tyson::Builder

  def self.new(app, options = {})
    builder = ::Rack::Builder.new
    warden_stratagies   = options[:warden_stratagies] || [:omniauth]
    warden_failure_app  = options[:failure_app]       || MusicGlue::Tyson::MissingAuthentication

    @user_authenticator = options[:user_authenticator]

    oauth_id, oauth_secret, oauth_options = extract_options!(options)
    unless options[:disabled]
      builder.use OmniAuth::Builder do
        provider :music_glue, oauth_id, oauth_secret, oauth_options
      end
      builder.use(Rack::Session::Cookie, :secret => "COOKIES") unless defined?('RailsWarden')

      builder.use warden_manager do |manager|
        manager.default_strategies warden_stratagies
        manager.failure_app = warden_failure_app

        Warden::Strategies.add :omniauth, MusicGlue::Tyson::Strategies::Omniauth


        Warden::Manager.serialize_into_session do |user|
          user.attributes
        end

        Warden::Manager.serialize_from_session do |attrs|
          MusicGlue::Tyson::User.new attrs
        end

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

  def self.warden_manager
    if defined?('RailsWarden')
      RailsWarden::Manager
    else
      Warden::Manager
    end
  end

end
