module MusicGlue
  class Tyson::MissingAuthentication

    def self.call(env)
      req = Rack::Request.new(env)
      res = Rack::Response.new

      req.session['user.return_to'] = req.env['REQUEST_PATH']

      res.redirect("/auth/music_glue?redirect_to=#{req.session['user.return_to']}")
      res.finish
    end

  end
end
