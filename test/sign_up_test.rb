require "test_helper"

class SessionSignUpTest < MiniTest::Spec
  it "successfuly creates and authenticates new user" do
    res = Tyrant::SignUp.(params: {
      email: "selectport@trb.org",
      password: "123123",
      password_confirmation: "123123",
    })

    res.success?.must_equal true

    res[:model].tap do|m|
      m.persisted?.must_equal true
      m.email.must_equal "selectport@trb.org"
      m.confirmation_token.wont_be_nil
      m.confirmed_at.must_be_nil
      m.confirmation_sent_at.must_be_close_to DateTime.now

      assert m.encrypted_password == "123123"
      m.encrypted_password.must_be_instance_of BCrypt::Password
    end
  end

  it "raises validation error" do
    res = Tyrant::SignUp.(params: {
      email: "",
      password: "",
      password_confirmation: "",
    })

    res.failure?.must_equal true
    res[:model].persisted?.must_equal false
    res["contract.default"].errors[:email].must_include "must be filled"
    res["contract.default"].errors[:password].must_include "must be filled"
  end

  it "raises validation error on password missmatch" do
    res = Tyrant::SignUp.(params: {
      email: "i@am.drunk",
      password: "drunk person",
      password_confirmation: "veeeeery druuunk",
    })

    res.failure?.must_equal true
    res[:model].persisted?.must_equal false
    res["contract.default"].errors[:password_confirmation].must_include "must be equal to drunk person"
  end

end
