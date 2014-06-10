require 'active_model'

class MusicGlue::Tyson::User
  include ActiveModel::Model

  attr_accessor :id, :email, :first_name, :last_name
  validates_presence_of :id, :email

  def attributes
    {
      id: id,
      email: email,
      first_name: first_name,
      last_name: last_name
    }
  end

  def oauth_credentials
    env['omniauth.auth']["credentials"]
  end


end
