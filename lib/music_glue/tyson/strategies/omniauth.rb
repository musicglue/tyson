require 'music_glue/tyson/user'

module MusicGlue
  class Tyson
    module Strategies
      class Omniauth < ::Warden::Strategies::Base
        def valid?
          !env['omniauth.auth'].nil?
        end

        def authenticate!
          auth = env['omniauth.auth']

          user = MusicGlue::Tyson::User.new({
            id: auth['uid'],
            email: auth['info']['email'],
            first_name: auth['info']['first_name'],
            last_name: auth['info']['last_name']
            })

          success! user
        end
      end
    end
  end
end
