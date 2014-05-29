require 'test_helper'

class StudentMailerTest < ActionMailer::TestCase
  test "password_reset" do
    mail = StudentMailer.password_reset
    assert_equal "Password reset", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
