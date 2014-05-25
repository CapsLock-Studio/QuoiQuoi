class OrderMailer < ActionMailer::Base
  # include Resque::Mailer
  default from: 'admin@quoiquoi.tw'

  def remind(order, locale_id, domain)

    @order = order
    @locale_id = locale_id
    @domain = domain
    mail(to: order.user.email, subject: '[quoiquoi.tw] 訂購完成通知信 (系統自動寄出請勿回覆)')
  end
end