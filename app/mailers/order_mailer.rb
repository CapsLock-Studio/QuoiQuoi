class OrderMailer < ActionMailer::Base
  # include Resque::Mailer
  default from: 'admin@quoiquoi.tw'

  def remind(order, domain)
    I18n.locale = Locale.find(order.locale_id).lang

    shipping_fee = ShippingFeeTranslate.where(shipping_fee_id: order.shipping_fee_id, locale_id: order.locale_id).first
    @fee = shipping_fee.fee
    if !shipping_fee.free_condition.blank? && (order.subtotal > shipping_fee.free_condition)
      @fee = 0
    end

    @order = order
    @domain = domain
    mail(to: order.user.email, subject: t('mailer.subject_for_order'))
  end

  def re_remittance_remind(order, domain)
    I18n.locale = Locale.find(order.locale_id).lang

    shipping_fee = ShippingFeeTranslate.where(shipping_fee_id: order.shipping_fee_id, locale_id: order.locale_id).first
    @fee = shipping_fee.fee
    if !shipping_fee.free_condition.blank? && (order.subtotal > shipping_fee.free_condition)
      @fee = 0
    end

    @order = order
    @domain = domain
    mail(to: order.user.email, subject: t('mailer.subject_for_re_remittance'))
  end

  def remittance_remind(order, domain)
    I18n.locale = Locale.find(order.locale_id).lang

    shipping_fee = ShippingFeeTranslate.where(shipping_fee_id: order.shipping_fee_id, locale_id: order.locale_id).first
    @fee = shipping_fee.fee
    if !shipping_fee.free_condition.blank? && (order.subtotal > shipping_fee.free_condition)
      @fee = 0
    end

    @order = order
    @domain = domain
    mail(to: order.user.email, subject: t('mailer.subject_for_remittance_order'))
  end

  def remittance_remind_three_days(order)
    I18n.locale = Locale.find(order.locale_id).lang

    shipping_fee = ShippingFeeTranslate.where(shipping_fee_id: order.shipping_fee_id, locale_id: order.locale_id).first
    @fee = shipping_fee.fee
    if !shipping_fee.free_condition.blank? && (order.subtotal > shipping_fee.free_condition)
      @fee = 0
    end

    @order = order
    mail(to: order.user.email, subject: t('mailer.subject_for_remittance_order'))
  end

  def delivered(order, domain)
    I18n.locale = Locale.find(order.locale_id).lang

    shipping_fee = ShippingFeeTranslate.where(shipping_fee_id: order.shipping_fee_id, locale_id: order.locale_id).first
    @fee = shipping_fee.fee
    if !shipping_fee.free_condition.blank? && (order.subtotal > shipping_fee.free_condition)
      @fee = 0
    end

    @order = order
    @domain = domain

    mail(to: order.user.email, subject: t('mailer.subject_for_deliver_order'))
  end
end