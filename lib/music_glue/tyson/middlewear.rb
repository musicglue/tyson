require 'sinatra/base'

module MusicGlue
  class Tyson::Middleware < Sinatra::Base

  enable :raise_errors
  disable :show_exceptions

  def initialize(app, options = {})
    if options[:disabled]
      @app = app
      @disabled = true
      # super is not called; we're not using sinatra if we're disabled
    else
      super(app)
      @musicglue_only = extract_option(options, :musicglue_only, false)
    end
  end

  def call(env)
    if @disabled || skip?(env)
      @app.call(env)
    else
      super(env)
    end
  end

  get '/test-uri' do
    binding.pry
  end
end
