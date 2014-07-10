# encoding : utf-8
namespace :payment do
  desc 'Auto send over three day not remittance payment the remittance remind mail and if over five days cancel the payment'
  task cancel: :environment do
    Payment.where(completed: false, pay_time: nil).where('created_at < ?', 5.days.ago).destroy_all
  end

  task send_remind_mail: :environment do
    payments = Payment.where(completed: false, pay_time: nil).where('created_at < ? and created_at > ?', 3.days.ago, 4.days.ago).all

    payments.each do |payment|
      if payment.order
        OrderMailer.remittance_remind_three_days(payment.order_id).deliver
        puts 'send order remind mail'
      elsif payment.registration
        RegistrationMailer.remittance_remind_three_days(payment.registration_id).deliver
        puts 'send registration remind mail'
      elsif payment.user_gift
        UserGiftMailer.remittance_remind_three_days(payment.user_gift_id).deliver
        puts 'send user card remind mail'
      end
    end
  end
end