# define Heroku and Heroku::Bouncer
module MusicGlue
  class Tyson
    def self.new(*args)
      require 'music_glue/tyson/builder'
      MusicGlue::Tyson::Builder.new(*args)
    end
  end
end

