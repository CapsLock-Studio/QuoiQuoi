class CustomMailer < ApplicationMailer
  def approve(id)
    custom_order = CustomOrder.find(id)

    @custom_order_id = custom_order.id
    @price = custom_order.price

    @locale_id = custom_order.locale_id
    I18n.locale = custom_order.locale.lang

    mail(to: custom_order.email, subject: t('mailer.subject.custom.approve'))
  end

  def dismiss(id)
    custom_order = CustomOrder.find(id)

    @message = custom_order.dismiss_message
    @custom_order_id = custom_order.id

    @locale_id = custom_order.locale_id

    mail(to: custom_order.email, subject: t('mailer.subject.custom.dismiss'))
  end

  def remind_new_order(id)
    @custom_order = CustomOrder.find(id)

    mail(to: $redis.get('about:locale:1:email'), subject: "[quoiquoi.tw] 系統提醒 有新建立訂製訂單#{@custom_order.id} - 請注意客戶的訂製需求")
  end
end