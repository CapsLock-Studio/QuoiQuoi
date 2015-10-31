class OrderPaymentController < ApplicationController
  before_action :checkout, except: [:resume, :webatm_resume, :alipay_resume]
  before_action :set_breadcrumb

  def remittance
    flash[:icon] = 'fa-smile-o'
    flash[:message] = '謝謝你！訂單已經成立。請你注意繳費期限以免訂單自動取消喔！'
    flash[:status] = 'success'

    @order.create_order_payment(
        {
            amount: @order.subtotal,
            expire_time: Date.today + 7.days
        })

    redirect_to order_path(@order)
  end

  def cvs_ibon
    send_request_to_allpay(@order, 'CVS', {
                                          ChooseSubPayment: 'IBON',
                                      })
  end

  def cvs_family
    send_request_to_allpay(@order, 'CVS', {
                                          ChooseSubPayment: 'FAMILY',
                                      })
  end

  def resume
    order = duplicate_order_payment(params[:id]).order

    case order.payment_method
      when order.payment_method['cvs_family']
        send_request_to_allpay(order, 'CVS', {
                                         ChooseSubPayment: 'FAMILY',
                                     })
      when order.payment_method['cvs_ibon']
        send_request_to_allpay(order, 'CVS', {
                                         ChooseSubPayment: 'IBON',
                                     })
      when order.payment_method['atm']
        send_request_to_allpay(order, 'ATM')
      else
        render json: 'ERROR!!'
    end
  end

  def paypal

    #render json: Paypal::Express::Request.new(PAYPAL_CONFIG)
    paypal_response = Paypal::Express::Request.new(PAYPAL_CONFIG).setup(
        Paypal::Payment::Request.new(
            currency_code: Locale.find(@order.locale_id).currency_code,
            description: @website_title,
            quantity: 1,
            amount: @order.subtotal
        ),
        url_for(controller: :order_payment_callback, action: :paypal),
        cancel_order_url(@order),
        pay_on_paypal: true,
        no_shipping: true
    )

    @order.create_order_payment(
        {
            redirect_uri: paypal_response.redirect_uri,
            token: paypal_response.token,
            amount: @order.subtotal,
            trade_time: paypal_response.timestamp
        })

    redirect_to paypal_response.redirect_uri
  end

  def webatm
    send_request_to_allpay(@order, 'WebATM', {
                                          OrderResultURL: return_order_url(@order)
                                      })
  end

  def webatm_resume
    order_payment = duplicate_order_payment(params[:id])

    # Resend a order payment to AllPay
    send_request_to_allpay(order_payment.order, 'WebATM', {
                                                       OrderResultURL: return_order_url(order_payment.order)
                                                   })
  end

  def atm
    send_request_to_allpay(@order, 'ATM')
  end

  def alipay
    item_names = @order.order_products.map{|order_products| "#{order_products.product.product_translates.find_by_locale_id(@order.locale_id).name}" }
    item_counts = @order.order_products.map{|order_products| "#{order_products.quantity}" }
    item_prices = @order.order_products.map{|order_products| "#{order_products.price.to_i}" }

    if @order.shipping_fee! > 0
      item_names << "#{t('shipping_fee')}"
      item_counts << "1"
      item_prices << "#{@order.shipping_fee!.to_i}"
    end

    send_request_to_allpay(@order, 'Alipay', {
                                    AlipayItemName: item_names.join('#'),
                                    AlipayItemCounts: item_counts.join('#'),
                                    AlipayItemPrice: item_prices.join('#'),
                                    Email: @order.user.email,
                                    PhoneNo: @order.phone,
                                    UserName: @order.name
                                      })
  end

  def alipay_resume
    order_payment = duplicate_order_payment(params[:id])
    order = order_payment.order

    item_names = order.order_products.map{|order_products| "#{order_products.product.product_translates.find_by_locale_id(order.locale_id).name}" }
    item_counts = order.order_products.map{|order_products| "#{order_products.quantity}" }
    item_prices = order.order_products.map{|order_products| "#{order_products.price.to_i}" }

    if order.shipping_fee! > 0
      item_names << "#{t('shipping_fee')}"
      item_counts << "1"
      item_prices << "#{order.shipping_fee!.to_i}"
    end

    # Resend a order payment to AllPay
    send_request_to_allpay(order_payment.order, 'Alipay', {
                                                       AlipayItemName: item_names.join('#'),
                                                       AlipayItemCounts: item_counts.join('#'),
                                                       AlipayItemPrice: item_prices.join('#'),
                                                       Email: order_payment.order.user.email,
                                                       PhoneNo: order_payment.order.phone,
                                                       UserName: order_payment.order.name
                                                   })
  end

  private
  def checkout
    @order = @order_in_cart

    @order_in_cart.checkout = true
    @order_in_cart.checkout_time = Time.now

    @order_in_cart.save!
  end

  def set_breadcrumb
    add_breadcrumb t('home'), :root_path
    add_breadcrumb I18n.t('cart'), :cart_path
    add_breadcrumb I18n.t('check_out')
  end

  def send_request_to_allpay(order, payment, options = nil)
    @form_data = {
        MerchantID: AllPay.merchant_id,
        MerchantTradeNo: "O#{order.id}",
        MerchantTradeDate: order.checkout_time.strftime('%Y/%m/%d %H:%I:%S'),
        PaymentType: 'aio',
        TotalAmount: order.subtotal.to_i,
        TradeDesc: @website_title,
        ItemName: order.order_products.map{|order_products|
          "#{order_products.product.product_translates.find_by_locale_id(order.locale_id).name} x #{order_products.quantity}"
        }.join('#'),
        ReturnURL: url_for(controller: :order_payment_callback, action: :allpay_complete),
        ChoosePayment: payment,
        ClientRedirectURL: order_url(order),
    }

    unless options.nil?
      @form_data = @form_data.merge(options)
    end

    # render json: @form_data

    # Record payment information
    order.create_order_payment(
        {
            amount: order.subtotal
        })

    render template: 'order_payment/all_pay_form'
  end

  def duplicate_order_payment(id)
    # We need to resend the order again but the previous MerchantTradeNo has exists
    # So duplicate the entry then send it to AllPay.
    order_payment = OrderPayment.find(id)

    order = order_payment.order.dup
    order.save!

    # Set order_products to newest one
    order_payment.order.order_products.each do |order_product|
      order_product.update_column(:order_id, order.id)
    end

    order_payment.order.delete
    order_payment.order_id = order.id
    order_payment.save!

    order_payment
  end
end
