module MusicGlue
  class Tyson::MissingAuthentication

    def self.call(env)
      redirect_to('/test')
    end

  end
end
