class OrderMailer < ActionMailer::Base
  # include Resque::Mailer
  default from: 'admin@quoiquoi.tw'

  def remind(order, locale_id, domain)

    @order = order
    @locale_id = locale_id
    @domain = domain
    mail(to: order.user.email, subject: t('mailer.subject_for_order'))
  end

  def remittance_remind(order, locale_id, domain)
    @order = order
    @locale_id = locale_id
    @domain = domain
    mail(to: order.user.email, subject: t('mailer.subject_for_order'))
  end
end