class OrderMailer < ActionMailer::Base
  include Resque::Mailer
  default from: 'admin@quoiquoi.tw'
  add_template_helper(ApplicationHelper)

  def remind(order_id)
    @order = Order.find(order_id)
    I18n.locale = Locale.find(@order.locale_id).lang

    shipping_fee = ShippingFeeTranslate.where(shipping_fee_id: @order.shipping_fee_id, locale_id: @order.locale_id).first
    @fee = shipping_fee.fee
    if !shipping_fee.free_condition.blank? && (@order.subtotal >= shipping_fee.free_condition)
      @fee = 0
    end

    set_discount

    mail(to: @order.user.email, subject: t('mailer.subject_for_order'))
  end

  def re_remittance_remind(order_id, amount, identifier, pay_time)
    @order = Order.find(order_id)
    I18n.locale = Locale.find(@order.locale_id).lang

    @order.payment.amount = amount
    @order.payment.identifier = identifier
    @order.payment.pay_time = pay_time

    shipping_fee = ShippingFeeTranslate.where(shipping_fee_id: @order.shipping_fee_id, locale_id: @order.locale_id).first
    @fee = shipping_fee.fee
    if !shipping_fee.free_condition.blank? && (@order.subtotal >= shipping_fee.free_condition)
      @fee = 0
    end

    set_discount

    mail(to: @order.user.email, subject: t('mailer.subject_for_re_remittance'))
  end

  def remittance_remind(order_id)
    @order = Order.find(order_id)
    I18n.locale = Locale.find(@order.locale_id).lang

    shipping_fee = ShippingFeeTranslate.where(shipping_fee_id: @order.shipping_fee_id, locale_id: @order.locale_id).first
    @fee = shipping_fee.fee
    if !shipping_fee.free_condition.blank? && (@order.subtotal >= shipping_fee.free_condition)
      @fee = 0
    end

    set_discount

    mail(to: @order.user.email, subject: t('mailer.subject_for_remittance_order'))
  end

  def remittance_remind_three_days(order_id)
    @order = Order.find(order_id)
    I18n.locale = Locale.find(@order.locale_id).lang

    shipping_fee = ShippingFeeTranslate.where(shipping_fee_id: @order.shipping_fee_id, locale_id: @order.locale_id).first
    @fee = shipping_fee.fee
    if !shipping_fee.free_condition.blank? && (@order.subtotal >= shipping_fee.free_condition)
      @fee = 0
    end

    set_discount

    mail(to: @order.user.email, subject: t('mailer.subject_for_three_days'))
  end

  def delivered(order_id)
    @order = Order.find(order_id)
    I18n.locale = Locale.find(@order.locale_id).lang

    shipping_fee = ShippingFeeTranslate.where(shipping_fee_id: @order.shipping_fee_id, locale_id: @order.locale_id).first
    @fee = shipping_fee.fee
    if !shipping_fee.free_condition.blank? && (@order.subtotal >= shipping_fee.free_condition)
      @fee = 0
    end

    set_discount

    mail(to: @order.user.email, subject: t('mailer.subject_for_deliver_order'))
  end

  private
  def set_discount
    @user_gift_serials = UserGiftSerial.where(order_id: @order.id)
    @discount = 0
    @user_gift_serials.each do |user_gift_serial|
      @discount += user_gift_serial.user_gift.gift.gift_translates.where(locale_id: @order.locale_id).first.quota
    end
  end
end