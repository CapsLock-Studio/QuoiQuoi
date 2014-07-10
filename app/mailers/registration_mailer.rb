class RegistrationMailer < ActionMailer::Base
  include Resque::Mailer
  default from: 'admin@quoiquoi.tw'

  def remittance_remind(registration_id)
    @registration = Registration.find(registration_id)
    I18n.locale = Locale.find(@registration.locale_id).lang

    set_discount

    mail(to: (@registration.user)? @registration.user.email : @registration.email, subject: t('mailer.subject_for_remittance_registration'))
  end

  def remittance_remind_three_days(registration_id)
    @registration = Registration.find(registration_id)
    I18n.locale = Locale.find(@registration.locale_id).lang

    set_discount

    mail(to: (@registration.user)? @registration.user.email : @registration.email, subject: t('mailer.subject_for_three_days'))
  end

  def remind(registration_id)
    @registration = Registration.find(registration_id)
    I18n.locale = Locale.find(@registration.locale_id).lang

    set_discount

    mail(to: (@registration.user)? @registration.user.email : @registration.email, subject: t('mailer.subject_for_registration'))
  end

  def re_remittance_remind(registration_id, amount, identifier, pay_time)
    @registration = Registration.find(registration_id)
    I18n.locale = Locale.find(@registration.locale_id).lang

    @registration.payment.amount = amount
    @registration.payment.identifier = identifier
    @registration.payment.pay_time = pay_time

    set_discount

    mail(to: (@registration.user)? @registration.user.email : @registration.email, subject: t('mailer.subject_for_re_remittance'))
  end

  def cancel_remind(registration_id)
    @registration = Registration.find(registration_id)
    I18n.locale = Locale.find(@registration.locale_id).lang

    set_discount

    mail(to: (@registration.user)? @registration.user.email : @registration.email, subject: "#{t('mailer.subject_for_cancel_registration')} #{t('mailer.help_return_tuition') if @registration.payment && @registration.payment.completed?}")
  end

  private
    def set_discount
      @discount = 0
      UserGiftSerial.where(registration_id: @registration.id).each do |user_gift_serial|
        @discount += user_gift_serial.user_gift.gift.gift_translates.where(locale_id: @registration.locale_id).first.quota
      end
    end
end