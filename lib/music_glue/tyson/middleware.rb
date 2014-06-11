require 'sinatra/base'

class MusicGlue::Tyson::Middleware < Sinatra::Base

  enable :raise_errors
  disable :show_exceptions

  def initialize(app, options = {})
    if options[:disabled]
      @app = app
      @disabled = true
      # super is not called; we're not using sinatra if we're disabled
    else
      super(app)
      @musicglue_only = options[:musicglue_only] || false
    end
  end

  def call(env)
    if @disabled
      @app.call(env)
    else
      super(env)
    end
  end

  before do
    if user = env['warden'].user
      if user.session_nonce != request.cookies['mg_session_nonce']
        request.session['user.return_to'] = env['REQUEST_PATH']
        env['warden'].logout
      elsif @musicglue_only && !user.mg_all_star?
        unless user.mg_all_star?
          env['warden'].logout
          redirect("#{ENV['MUSIC_GLUE_AUTH_URL']}/")
        end
      end
    end
  end

  get '/auth/music_glue/callback' do
    env['warden'].authenticate!
    redirect(session['user.return_to'] || '/')
  end

  get '/auth/logout-sso' do
    env['warden'].logout
    redirect("#{ENV['MUSIC_GLUE_AUTH_URL']}/users/sign_out/sso")
  end



end
