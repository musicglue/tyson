require 'rack/builder'
require 'warden'
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
    cookie_secret       = options.fetch(:cookie_secret) { 'COOKIES' }
    logger              = options.fetch(:logger) { Logger.new STDOUT }

    oauth_id, oauth_secret, oauth_options = extract_options!(options, logger)

    unless options[:disabled]
      builder.use OmniAuth::Builder do
        provider :music_glue, oauth_id, oauth_secret, oauth_options
      end

      builder.use(Rack::Session::Cookie, :secret => cookie_secret) unless defined?('RailsWarden')

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


  def self.extract_options!(options, logger)
    oauth = options[:oauth] || {}
    oauth_options = options[:oauth_options] || {}
    id, secret = oauth[:id], oauth[:secret]

    if id.nil? || secret.nil? || id.empty? || secret.empty?
      if options[:fail_without_config]
        fail 'music_glue-tyson requires :id and :secret oauth options in this environment.'
      else
        logger.warn "music_glue-tyson is disabled because it's :id or :secret oauth options are missing."
      end

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
