class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :cancel, :delivery_report, :close_show, :close, :pay_show, :report_remittance]
  before_action :authenticate_user!

  skip_before_action :verify_authenticity_token, only: [:update, :return]

  def index
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('order.all'), :orders_path

    @orders = Order.where(closed: false, checkout: true, user_id: current_user.id, canceled: false).order(:id)
  end

  # GET /orders/1
  def show
    if @order.empty_expire_time?
      redirect_to controller: :order_payment, action: :resume, id: @order.id
    else
      add_breadcrumb t('home'), :root_path
      add_breadcrumb t('order.all'), :orders_path
      add_breadcrumb t('detail')

      @discount = 0

      begin
        @discount = @order
                        .user_gift_serial
                        .user_gift.gift
                        .gift_translates
                        .find_by_locale_id(@order.locale_id)
                        .quota
      end
    end
  end

  def create
    @order_in_cart.order_products.each do |order_product|
      product = Product.find(order_product.product)
      if product.quantity - order_product.quantity < 0
        format.html {render json: 'Products are sold out.'}
      else
        product.update_attribute(:quantity, product.quantity - order_product.quantity)
      end
    end

    # Checkout when payment complete
    # @order_in_cart.checkout = true
    # @order_in_cart.checkout_time = Time.now
    @order_in_cart.subtotal = @order_in_cart.get_subtotal

    begin
      if !params[:user_gift_serial].nil? && params[:user_gift_serial] != ''
        user_gift_serial = UserGiftSerial.find_by_serial(params[:user_gift_serial])
        discount = user_gift_serial
                        .user_gift
                        .gift
                        .gift_translates
                        .find_by_locale_id(@order_in_cart.locale_id)
                        .quota

        @order_in_cart.subtotal -= discount

        user_gift_serial.order_id = @order_in_cart.id
        user_gift_serial.used_time = Time.now
        user_gift_serial.email = @order_in_cart.user.email
        user_gift_serial.save

        UserGiftMailer.used_remind(user_gift_serial.id).deliver_later
      end
    rescue

    end

    if @order_in_cart.update(order_params) && @order_in_cart.save

      @order_in_cart.reload

      # Using class instead of redirect?
      # No, if we using the class to handle work, how do we show page?
      redirect_to controller: :order_payment, action: @order_in_cart.payment_method
    else
      render json: @order.errors
    end
  end

  # PUT/PATCH or POST /orders/1
  # Receive CVS and ATM result here.
  def update
    flash.now[:icon] = 'fa-smile-o'
    flash.now[:message] = t('order_complete_hint')
    flash.now[:status] = 'success'

    @order = Order.find(params['MerchantTradeNo'].delete('O'))
    # Check token to detect if post is from allpay
    # When payment method is CVS, RtnCode will return '1010073',
    # method is ATM, RtbCode will be '2'
    unless @order.order_payment.nil?

      if params['RtnCode'] == '10100073' || params['RtnCode'] == '2'
        @order.order_payment.update(
            {
                expire_time: params['ExpireDate'],
                trade_no: params['TradeNo'],
                trade_time: params['TradeDate'],
                payment_no: params['PaymentNo'],
                bankcode: params['BankCode'],
                account: params['vAccount']
            }
        )

        @order.reload

        if @order.atm?
          subject = t('mailer.subject.payment.atm')
        else
          subject = t('mailer.subject.payment.cvs')
        end

        OrderMailer.remind_to_pay(@order.id, subject).deliver_later

        add_breadcrumb t('home'), :root_path
        add_breadcrumb t('order.all'), :orders_path
        add_breadcrumb t('detail')

        render action: :show
      else
        render json: 'Not support payment method.'
      end
    else
      render json: 'Order not found.'
    end
  end

  def destroy
  end

  def cancel
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('order.all'), :orders_path
    add_breadcrumb t('detail')

    if !@order.order_payment.completed? && !@order.order_payment.cancel?
      flash.now[:icon] = 'fa-user-times'
      flash.now[:message] = t('order_cancel')
      flash.now[:status] = 'success'

      @order.order_payment.cancel = true
      @order.order_payment.cancel_reason = params[:cancel_reason]
      @order.order_payment.cancel_time = Time.now
      @order.order_payment.save!
    else
      flash.now[:icon] = 'fa-lightbulb-o'
      flash.now[:status] = 'success'
      flash.now[:message] = t('payment_already_completed')
    end

    render action: :show
  end

  def delivery_report
    unless @order.delivery_report?
      flash.now[:icon] = 'fa-exclamation-triangle'
      flash.now[:message] = t('report_problem_hint')
      flash.now[:status] = 'success'

      @order.delivery_report = true
      @order.delivery_report_message = params[:delivery_report_message]
      @order.delivery_report_time = Time.now
      @order.save!

      OrderMailer.report_deliver_problem(@order.id).deliver_later
    end

    render action: :show
  end

  def report_remittance
    # Status ==> Waiting   -> confirm: nil
    #            Confirmed -> confirm: true
    #            Confirmed -> confirm: false
    # If there are any reports waiting be reviewed, do nothing and show message to customer
    if @order.order_payment.order_remittance_reports.where(confirm: nil).size <= 0
      report = @order.order_payment.order_remittance_reports.create({
                                                               amount: params[:amount],
                                                               account: params[:account],
                                                               date: params[:date]
                                                           })

      OrderMailer.remind_remittance_report(report).deliver_later

      flash.now[:icon] = 'fa-smile-o'
      flash.now[:status] = 'success'
      flash.now[:message] = t('report_remittance_hint')
    else
      flash.now[:icon] = 'fa-frown-o'
      flash.now[:status] = 'warning'
      flash.now[:message] = t('report_remittance_warning')
    end

    render action: :show
  end

  ###################### Discarded code ##########################

  # # GET /orders/close
  # def close_index
  #   add_breadcrumb t('home'), :root_path
  #   add_breadcrumb t('order.closed')
  #   @orders = Order.where(closed: true, user_id: current_user.id)
  #
  #   respond_to do |format|
  #     format.html {render action: :index}
  #   end
  # end
  #
  # # GET /orders/1/close
  # def close_show
  #   add_breadcrumb t('home'), :root_path
  #   add_breadcrumb t('order.closed'), :close_orders_path
  #   add_breadcrumb t('detail')
  #
  #
  #
  #   respond_to do |format|
  #     format.html {render action: :show}
  #   end
  # end

  # # PUT/PATCH /orders/1/close
  # def close
  #   if @order.paid? && @order.delivered?
  #     respond_to do |format|
  #       if @order.update_attributes({closed: true, closed_time: Time.now})
  #         format.html {redirect_to close_order_path(@order)}
  #       else
  #         format.html {render json: @order.errors}
  #       end
  #     end
  #   else
  #     respond_to do |format|
  #       format.html {render action: :show}
  #     end
  #   end
  # end
  #
  # # GET /orders/1/pay
  # def pay_show
  #   if @order.payment
  #
  #     # if payment completed redirect to registrations page, not allow user to choose pay way again
  #     # then, if the payment is not completed, we need to delete uncompleted payment and let user to choose pay way again
  #     if @order.payment.completed?
  #       redirect_to order_path(@order)
  #     else
  #       @order.payment.destroy
  #       @payment = @order.build_payment
  #     end
  #   else
  #
  #     # has not choose pay way yet
  #     @payment = @order.build_payment
  #   end
  # end

  ###################### Discarded code ##########################

  def return
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('order.in_trading'), :orders_path
    add_breadcrumb t('detail')

    @order = Order.find(params['MerchantTradeNo'].delete('O').split('t')[0])

    if params['RtnCode'] == '1' || params['RtnCode'] == '3'
      flash.now[:icon] = 'fa-smile-o'
      flash.now[:status] = 'success'
      flash.now[:message] = t('payment_completed')

      # Not really update order entity, just show the newest status.
      @order.order_payment.trade_no = params['TradeNo']
      @order.order_payment.trade_time = params['TradeDate']
      @order.order_payment.payment_time = params['PaymentDate']
      @order.order_payment.completed =  true
      @order.order_payment.completed_time = Time.now

      @order.order_payment.save!

      OrderMailer.completed_confirmation(@order.id).deliver_later
    else
      errorCodes = JSON.parse(File.read('app/assets/javascripts/ecpayErrorCodes.json'))

      flash.now[:icon] = 'fa-exclamation-triangle'
      flash.now[:status] = 'danger'
      flash.now[:message] = "#{t('error_code')}: #{params['RtnCode']}, #{errorCodes[params['RtnCode']]} 🚫 #{t('payment_failed')}"
    end

    render 'orders/show'
  end

  private
    def set_order
      @order = Order.find_by_id_and_user_id(params[:id], current_user.id)
    end

    def order_params
      params[:order][:payment_method] = params[:order][:payment_method].to_i

      params.require(:order).permit(:name, :address, :phone, :zip_code, :shipping_fee_id, :payment_method)
    end

    #def set_discount
    #  @discount = 0
    #  UserGiftSerial.where(order_id: @order.id).each do |user_gift_serial|
    #    @discount += user_gift_serial.user_gift.gift.gift_translates.where(locale_id: @order.locale_id).first.quota
    #  end
    #end
end
