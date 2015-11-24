namespace :migrate do
  desc 'migrate old payment data to new data structure'
  task payment: :environment do
    Payment.all.reject{|p| p.order_id.nil? && p.registration_id.nil?}.each do |payment|
      if !payment.order_id.blank? && !payment.order.nil?
        payment_object = OrderPayment.new
        payment_object.order_id = payment.order_id

        if payment.wait?
          payment_object.amount = payment.order.subtotal

          payment_object.save

          unless payment.amount.blank?
            report = OrderRemittanceReport.new
            report.amount = payment.amount
            report.account = payment.identifier
            report.date = payment.pay_time
            report.order_payment_id = payment_object.id

            if payment.completed?
              report.confirm = true
            else
              report.confirm = false
            end
            report.save
          end
        else
          # Paypal
          payment_object.amount = payment.amount
          payment_object.token = payment.token
          payment_object.trade_no = payment.identifier
          payment_object.payer_id = payment.payer_id
          payment_object.completed = payment.completed
          payment_object.completed_time = payment.pay_time
          payment_object.created_at = payment.created_at
          payment_object.updated_at = payment.updated_at
          payment_object.payment_time = payment.pay_time

          payment_object.save
        end
      end

      if !payment.registration_id.blank? && !payment.registration.nil?
        payment_object = RegistrationPayment.new
        payment_object.registration_id = payment.registration_id

        if payment.wait?
          payment_object.amount = payment.registration.subtotal
          payment_object.save

          unless payment.amount.blank?
            report = RegistrationRemittanceReport.new
            report.amount = payment.amount
            report.account = payment.identifier
            report.date = payment.pay_time
            report.registration_payment_id = payment_object.id

            if payment.completed?
              report.confirm = true
            else
              report.confirm = false
            end
            report.save
          end
        else
          # Paypal
          payment_object.amount = payment.amount
          payment_object.token = payment.token
          payment_object.trade_no = payment.identifier
          payment_object.payer_id = payment.payer_id
          payment_object.completed = payment.completed
          payment_object.completed_time = payment.pay_time
          payment_object.created_at = payment.created_at
          payment_object.updated_at = payment.updated_at
          payment_object.payment_time = payment.pay_time

          payment_object.save
        end
      end
    end
  end

  desc 'migrate old payment method to new model'
  task payment_method: :environment do
    Payment.all.reject{|p| p.order_id.nil? && p.registration_id.nil?}.each do |payment|
      if !payment.order_id.blank? && !payment.order.nil?
        if payment.wait?
          payment.order.payment_method = 0
        else
          payment.order.payment_method = 0
        end

        payment.order.save
      end

      if !payment.registration_id.blank? && !payment.registration.nil?
        if payment.wait?
          payment.registration.payment_method = 0
        else
          payment.registration.payment_method = 0
        end

        payment.registration.save
      end
    end
  end

  desc 'migrate old order custom item to new custom order'
  task custom_order: :environment do
    locale_id = Locale.find_by_lang('zh-TW').id
    OrderCustomItem.where.not(user_id: nil).each do |item|
      custom_order = CustomOrder.new
      custom_order.order_type = item.design
      custom_order.style = item.style
      custom_order.materials = OrderCustomItemMaterial.where(order_custom_item_id: item.id).pluck(:material_id).to_json
      custom_order.approve = item.accept
      custom_order.approve_time = item.accept_time
      custom_order.phone = item.phone
      custom_order.email = User.find(item.user_id).email
      custom_order.line = item.line
      custom_order.cancel = item.canceled
      custom_order.cancel_time = item.canceled_time
      custom_order.product_id = item.product_id
      custom_order.locale_id = locale_id
      custom_order.user_id = item.user_id
      custom_order.save

      unless item.order_id.blank?
        item.custom_order_id = custom_order.id
        item.locale_id = locale_id
        item.save
      end
    end
  end

  desc 'fuck'
  task fix_payment_data: :environment do
    RegistrationRemittanceReport.where(confirm: true).each do |report|
      old_payment = Payment.find_by_registration_id(report.registration_payment.registration_id)
      new_payment = report.registration_payment
      new_payment.completed = true
      new_payment.completed_time = old_payment.pay_time
      new_payment.save
    end

    Registration.where(canceled: true).each do |registration|
      new_payment = registration.registration_payment
      new_payment.cancel = true
      new_payment.cancel_time = registration.canceled_time
      new_payment.save!
    end

    RegistrationRemittanceReport.where(date: nil).update_all(date: Time.new(0))
    RegistrationPayment.where(cancel: true).update_all(cancel_reason: '')

    ######################
    OrderRemittanceReport.where(confirm: true).each do |report|
      old_payment = Payment.find_by_order_id(report.order_payment.order_id)
      new_payment = report.order_payment
      new_payment.completed = true
      new_payment.completed_time = old_payment.pay_time
      new_payment.save
    end

    # Order.where(canceled: true).each do |order|
    #   new_payment = order.order_payment
    #   new_payment.cancel = true
    #   new_payment.cancel_time = order.canceled_time
    #   new_payment.save!
    # end

    # OrderRemittanceReport.where(date: nil).update_all(date: Time.new(0))
    # OrderPayment.where(cancel: true).update_all(cancel_reason: '')
  end

  desc 'fix order and order payment'
  task fix_order: :environment do
    has_payment_orders = Payment.where.not(order_id: nil).pluck(:order_id)
    Order.where(checkout: true, canceled: false).where.not(id: has_payment_orders).each do |order|
      if order.order_payment.nil?
        op = order.build_order_payment
        op.amount = order.subtotal
        op.created_at = order.created_at
        op.updated_at = order.updated_at
        op.save
      end
    end
  end
end