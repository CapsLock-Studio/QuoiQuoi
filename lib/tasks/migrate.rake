namespace :migrate do
  desc 'migrate old payment data to new data structure'
  task payment: :environment do
    Payment.all.reject{|p| p.order_id.nil? && p.registration_id.nil?}.each do |payment|
      if !payment.order_id.blank? && !payment.order.nil?
        payment_object = OrderPayment.new

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

        if payment.wait?
          payment_object.amount = payment.registration.subtotal

          payment_object.save

          unless payment.amount.blank?
            report = RegistrationRemittanceReport.new
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
    OrderCustomItem.all.each do |item|
      custom_order = CustomOrder.new
      custom_order.order_type = item.design
      custom_order.style = item.style
      custom_order.materials = item.order_custom_item_materials.pluck(:id).to_json
      custom_order.approve = item.accept
      custom_order.approve_time = item.accept_time
      custom_order.phone = item.phone
      custom_order.email = item.user.email
      custom_order.line = item.line
      custom_order.cancel = item.canceled
      custom_order.cancel_time = item.canceled_time
      custom_order.product_id = item.product_id
      custom_order.locale_id = locale_id
      custom_order.save

      unless item.order_id.blank?
        item.custom_order_id = custom_order.id
        item.locale_id = locale_id
        item.save
      end
    end
  end
end