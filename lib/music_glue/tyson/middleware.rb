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

  get '/auth/music_glue/callback' do
    env['warden'].authenticate!
    redirect(session['user.return_to'] || '/')
  end

end
