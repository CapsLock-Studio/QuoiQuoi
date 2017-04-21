class OnlinePaymentRemindJob < ApplicationJob
  queue_as :default

  def perform(payment_object)
    # Do something later
    if !payment_object.cancel? && !payment_object.completed?
      if payment_object.is_a?(RegistrationPayment)
        RegistrationMailer.remind_to_pay(payment_object.registration_id, I18n.translate('mailer.subject.payment.online')).deliver_later
      end

      if payment_object.is_a?(OrderPayment)
        OrderMailer.remind_to_pay(payment_object.order_id, I18n.translate('mailer.subject.payment.online')).deliver_later
      end
    end
  end
end
