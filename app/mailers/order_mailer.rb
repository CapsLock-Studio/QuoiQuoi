class OrderMailer < ApplicationMailer
  def remind_to_pay(id, subject)
    @order = Order.find(id)
    @locale_id = @order.locale_id

    I18n.locale = @order.locale.lang

    # Setup expire payment clean job
    CleanExpirePaymentsJob.set(
        wait_until: (@order.order_payment.expire_time.nil?)? (Time.now + 3.days).end_of_day : @order.order_payment.expire_time
    ).perform_later(@order.order_payment, t('payment_expired'))

    mail(to: @order.user.email, subject: subject)
  end

  def request_remit_payment_again(id)
    @report = OrderRemittanceReport.find(id)
    @order = @report.order_payment.order
    @locale_id = @order.locale_id

    I18n.locale = @order.locale.lang

    mail(to: @order.user.email, subject: t('mailer.subject.payment.remittance_report_fail'))
  end

  def completed_confirmation(id)
    @order = Order.find(id)
    @locale_id = @order.locale_id

    I18n.locale = @order.locale.lang

    mail(to: @order.user.email, subject: t('mailer.subject.order'))

    OrderMailer.remind_completed(@order.id).deliver_later
  end

  def deliver_notification(id)
    @order = Order.find(id)
    @locale_id = @order.locale_id

    I18n.locale = @order.locale.lang

    mail(to: @order.user.email, from: $redis.get('about:locale:1:email'), subject: t('mailer.subject.delivered'))
  end

  # Send to manager for notification
  def remind_remittance_report(id)
    @report = OrderRemittanceReport.find(id)
    @order = @report.order_payment.order
    mail(to: $redis.get('about:locale:1:email'), subject: "[quoiquoi.tw] 系統提醒 訂單編號#{@order.id}有匯款回報 - 回報編號#{@report.id}待確認")
  end

  # Send to manager for notification
  def remind_completed(id)
    @order = Order.find(id)

    mail(to: $redis.get('about:locale:1:email'), subject: "[quoiquoi.tw] 系統提醒 訂單編號#{@order.id}付款已經完成 - 等待出貨中")
  end

  # Send to manager for notification
  def report_deliver_problem(id)
    @order = Order.find(id)

    mail(to: $redis.get('about:locale:1:email'), subject: "[quoiquoi.tw] 系統提醒 訂單編號#{@order.id} 客戶回報超過7天沒有收到貨件")
  end
end