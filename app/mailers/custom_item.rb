class CustomItem < ActionMailer::Base
  default from: 'admin@quoiquoi.tw'

  def decline(custom_item_id, lang)
    I18n.locale = lang

    @order_custom_item = OrderCustomItem.find(custom_item_id)

    mail(to: @order_custom_item.user.email, bcc: ['quoiquoi.tw@gmail.com'], subject: t('mailer.subject_for_decline_custom_order'))
  end

  def accept(custom_item_id, lang)
    I18n.locale = lang

    @order_custom_item = OrderCustomItem.find(custom_item_id)
    @locale = Locale.find_by_lang(lang)

    mail(to: @order_custom_item.user.email, bcc: ['quoiquoi.tw@gmail.com'], subject: t('mailer.subject_for_accpet_custom_order'))
  end
end
