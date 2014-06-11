require 'active_model'

class MusicGlue::Tyson::User
  include ActiveModel::Model

  attr_accessor :id, :email, :first_name, :last_name, :token, :refresh_token, :expires_at, :session_nonce
  validates_presence_of :id, :email

  def attributes
    {
      id: id,
      email: email,
      first_name: first_name,
      last_name: last_name,
      token: token,
      refresh_token: refresh_token,
      expires_at: expiry_time,
      session_nonce: session_nonce
    }
  end

  def mg_all_star?
    email.split('@').last == 'musicglue.com'
  end

  def expiry_time
    Time.at expires_at
  end

end
