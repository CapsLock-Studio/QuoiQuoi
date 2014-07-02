class CustomItem < ActionMailer::Base
  default from: 'admin@quoiquoi.tw'

  def decline(custom_item, lang)
    I18n.locale = lang

    @order_custom_item = custom_item

    mail(to: custom_item.user.email, subject: t('mailer.subject_for_decline_custom_order'))
  end

  def accept(custom_item, lang)
    I18n.locale = lang

    @order_custom_item = custom_item

    mail(to: custom_item.user.email, subject: t('mailer.subject_for_accpet_custom_order'))
  end
end
