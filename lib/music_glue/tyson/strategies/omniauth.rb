module MusicGlue
  class Tyson::Strategies::Omniauth < ::Warden::Strategies::Base
    def valid?
      !env['omniauth.auth'].nil?
    end

    def authenticate!
      auth = env['omniauth.auth']
      provider, uid = auth['provider'], auth['uid']
      user = User.where("#{provider}_uid".to_sym => uid).first

      if user.nil?
        throw :warden, message: I18n.t(:unrecognized_oauth_provider_user_id, provider: provider.capitalize)
      else
        env['authoriser'] = RegisteredUserAuthoriser.new user
        success! user
      end
    end
  end
end
