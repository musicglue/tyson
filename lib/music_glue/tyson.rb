require "music_glue/tyson/version"
require 'music_glue/tyson/builder'

module MusicGlue
  class Tyson
    VERSION = "0.0.1"

    def self.new(*args)
      MusicGlue::Tyson::Builder.new(*args)
    end
  end
end
