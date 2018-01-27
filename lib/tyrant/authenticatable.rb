require "bcrypt"
require 'securerandom'

module Tyrant
  # Encapsulates authentication management logic for a particular user.
  class Authenticatable < Disposable::Twin
    feature Sync

    property :secret_password, virtual: true
    property :encrypted_password
    property :confirmation_token
    property :confirmed_at
    property :confirmation_sent_at

    def sync
      generate_password
      generate_confirmation_token

      super
    end

    private

    def generate_password
      self.encrypted_password = BCrypt::Password.create(secret_password)

      self
    end

    def generate_confirmation_token
      self.confirmation_token   = SecureRandom.urlsafe_base64
      self.confirmation_sent_at = DateTime.now

      self
    end

    def confirmable!
      confirmation_token      = SecureRandom.urlsafe_base64
      confirmation_created_at = DateTime.now
      self
    end

    # without token, this decides whether the user model can be activated (e.g. via "set a password").
    # with token, this additionally tests if the token is correct.
    def confirmable?(token=false)
      persisted_token = confirmation_token

      # TODO: add expiry etc.
      return false unless (persisted_token.is_a?(String) and persisted_token.size > 0)

      return compare_token(token) unless token==false
      true
    end

    # alias_method :confirmed?, :confirmable?
    def confirmed?
      not confirmed_at.nil?
    end

    def confirmed!
      confirmation_token = nil
      confirmed_at       = DateTime.now
    end

    def compare_token(token)
      token == confirmation_token
    end

    def digest
      return unless password_digest

      BCrypt::Password.new(password_digest)
    end

    def digest!(password)
      password_digest = BCrypt::Password.create(password)
    end

    def digest?(password)
      digest == password
    end
  end
end
