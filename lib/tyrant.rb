require "tyrant/version"
require "trailblazer"
require "reform"
require "reform/form/dry"
require "disposable"

module Tyrant

  User = Struct.new(:id, :email, :encrypted_password, :confirmation_token, :confirmed_at,
                    :confirmation_sent_at, :password_salt) do
    def save
      @saved = true
    end

    def persisted?
      @saved or false
    end
  end

  module User::Contract
    class Create < Reform::Form
      feature Reform::Form::Dry

      property :email
      property :password, virtual: true
      property :password_confirmation, virtual: true

      validation :default do
        required(:email).filled
        required(:password).filled(min_size?: 6).confirmation
      end
    end
  end
end

require "tyrant/authenticatable"
require "tyrant/sign_up"
require "tyrant/session"
