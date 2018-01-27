# This class implements sign up operation aka registration
# When user is given a form to type in email and password/confirmation
#
# Somewhere inside your SignUp controller simply do this:
# Tyrant::SignUp.(params: form_params)
#
# If success it will create an uncomfirmed user
# You have to handle confirmation on your own
# All fields with encrypted password and confirmation token will set up for you

module Tyrant
  class SignUp < Trailblazer::Operation
    step Model(User, :new)
    step Contract::Build(constant: User::Contract::Create)
    step Contract::Validate()
    step :generate_auth_metadata
    step Contract::Persist()

    # Delegates password/token generation to Authenticatable
    def generate_auth_metadata(options, model:, params:, **)
      Authenticatable.new(
        model, secret_password: params[:password]
      ).sync
    end
  end
end
