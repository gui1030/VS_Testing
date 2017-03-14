class TokenService
  def self.new_token_for(tokenable)
    seed = SecureRandom.base64(32)
    token = Digest::SHA1.hexdigest(seed)

    tokenable.update(email_token: token)
    seed
  end
end
