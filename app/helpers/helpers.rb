class Helpers


  def self.is_logged_in?(session)
    true if session[:user_id]
  end
end
