require 'test_helper'

class OnlinePaymentRemindJobTest < ActiveJob::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @payment = registration_payments(:one)
  end

  test 'online payment remind job is queued' do
    assert_enqueued_jobs 1 do
      OnlinePaymentRemindJob.perform_later(@payment)
    end
  end
end
