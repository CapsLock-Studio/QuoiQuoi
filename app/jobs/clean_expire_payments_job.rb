class CleanExpirePaymentsJob < ActiveJob::Base
  queue_as :default

  def perform(payment_object, reason)
    # Do something later
    if !payment_object.cancel? && !payment_object.completed?
      payment_object.cancel = true
      payment_object.cancel_reason = reason
      payment_object.cancel_time = Time.now
      payment_object.save!
    end
  end
end
