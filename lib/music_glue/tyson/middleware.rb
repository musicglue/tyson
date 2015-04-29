require 'sinatra/base'

class MusicGlue::Tyson::Middleware < Sinatra::Base
  enable :raise_errors
  disable :show_exceptions

  NONCE_KEY = 'mg_session_nonce'

  def initialize(app, options = {})
    if options[:disabled]
      @app = app
      @disabled = true
      # super is not called; we're not using sinatra if we're disabled
    else
      @cookie_options = { domain: '.musicglue.com', path: '/' }
      @cookie_options.delete(:domain) if options[:disable_cookie_domain_scope]
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
      if user.session_nonce != request.cookies[NONCE_KEY]
        response.delete_cookie NONCE_KEY, @cookie_options
        request.session['user.return_to'] = env['REQUEST_PATH']
        env['warden'].logout
      elsif @musicglue_only && !user.mg_all_star?
        env['warden'].logout
        redirect("#{ENV['MUSIC_GLUE_AUTH_URL']}/")
      end
    end
  end

  get '/auth/music_glue/callback' do
    user = env['warden'].authenticate!
    response.set_cookie NONCE_KEY, @cookie_options.merge(value: user.session_nonce)
    redirect(session['user.return_to'] || '/')
  end

  get '/auth/logout-sso' do
    env['warden'].logout
    redirect("#{ENV['MUSIC_GLUE_AUTH_URL']}/users/sign_out/sso")
  end
end
