require 'test_helper'

class RegistrationMailerTest < ActionMailer::TestCase
  include ActiveJob::TestHelper
  # test "the truth" do
  #   assert true
  # end

  test 'email is enqueued to be delivered later' do
    assert_enqueued_jobs 1 do
      RegistrationMailer.remind_to_pay(112).deliver_later
    end
  end
end
