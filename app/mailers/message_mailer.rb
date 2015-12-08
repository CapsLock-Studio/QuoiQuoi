class MessageMailer < ApplicationMailer
  def remind_to_user(id)
    @message = Message.find(id)

    @locale_id = @message.custom_order.locale_id
    I18n.locale = @message.custom_order.locale.lang

    mail(to: @message.custom_order.email, bcc: ['quoiquoi.tw@gmail.com'], subject: '[quoi quoi 布知道] 新留言提醒')
  end

  def remind_to_admin(id)
    @message = Message.find(id)

    @locale_id = @message.custom_order.locale_id
    I18n.locale = @message.custom_order.locale.lang

    mail(to: $redis.get('about:locale:1:email'), subject: "[quoiquoi.tw] 系統提醒 訂製訂單#{@message.custom_order_id}有新留言")
  end
end
