# Bad code, it should be separate, like order_payment, registration_payment and gift_payment
# But i don't want to modify this part right now.
# This is in the to-do list to reconstruct next time.

class PaymentsController < ApplicationController
  before_action :set_payment, only: [:edit, :update]
  rescue_from Paypal::Exception::APIError, with: :paypal_api_error

  def create
    respond_to do |format|
      payment = Payment.new(payment_params)

      remove_exists

      amount = 0
      currency = :TWD
      if payment.order
        amount = payment.order.subtotal
        currency = payment.order.currency
      elsif payment.registration
        amount = payment.registration.subtotal
        currency = payment.registration.currency
      elsif payment.user_gift
        gift = GiftTranslate.where(locale_id: session[:locale_id], gift_id: payment.user_gift.gift_id).first
        amount = gift.quota * payment.user_gift.quantity
        currency = payment.user_gift.currency
      end

      # payment need manual check
      if payment_params[:wait] == 'true'
        payment.save!(validate: false)
        if payment.registration

          # send mail to remind that if the remittance not complete in three days, it will discard auto
          RegistrationMailer.remittance_remind(payment.registration_id).deliver
        elsif payment.order
          OrderMailer.remittance_remind(payment.order_id).deliver
        elsif payment.user_gift
          UserGiftMailer.remittance_remind(payment.user_gift_id).deliver
        end
        format.html {redirect_to edit_payment_path(payment)}
      else
        #format.html {render json: payment}

        payment.setup!(amount, currency, success_payments_url, cancel_payments_url)
        format.html {redirect_to payment.redirect_uri}
      end
    end
  end

  def success
    payment = Payment.find_by_token(params[:token])

    respond_to do |format|
      payment.complete!(params[:PayerID])
      if payment.order
        OrderMailer.remind(payment.order_id).deliver

        # show the message let users know their payment complete
        flash[:status] = 'success'
        flash[:message] = t('completed_payment')

        format.html {redirect_to order_path(payment.order)}
      elsif payment.registration
        RegistrationMailer.remind(payment.registration_id).deliver

        # show the message let users know their payment complete
        flash[:status] = 'success'
        flash[:message] = t('completed_payment')

        if payment.registration.user
          format.html {redirect_to course_path(payment.registration.course)}
        else
          format.html {redirect_to action: :show}
        end
      elsif payment.user_gift

        # show the message let users know their payment complete
        flash[:status] = 'success'
        flash[:message] = t('completed_payment')

        1..payment.user_gift.quantity.times do |i|
          UserGiftSerial.new(user_gift_id: payment.user_gift_id, serial: get_unique_random_string).save
        end

        UserGiftMailer.completed_remind(payment.user_gift_id).deliver
        format.html {redirect_to user_gift_path(payment.user_gift)}
      end
    end
  end

  def cancel
    payment = Payment.where(token: params[:token]).all.first

    respond_to do |format|
      payment.destroy
      if payment.order
        format.html {redirect_to pay_order_path(payment.order)}
      elsif payment.registration
        format.html {redirect_to pay_registration_path(payment.registration)}
      elsif payment.user_gift
        format.html {redirect_to pay_user_gift_path(payment.user_gift)}
      else
        format.html {render json: 'Paypal payment error!'}
      end
    end
  end

  def edit
    flash[:message] = t('remittance_edit_hint')
    flash[:status] = 'warning'
    begin
      @remittance_translate = Remittance.find(1).remittance_translates.where(locale_id: session[:locale_id]).first
    rescue ActiveRecord::RecordNotFound
      @remittance_translate = nil
    end
  end

  def update
    flash[:message] = nil

    respond_to do |format|
      #format.html {render json: @payment}
      if @payment.update_attributes(payment_params.merge({token: Base64.encode64("#{Time.now}#{(0..3).map{('a'..'z').to_a[rand(26)]}.join}"), wait: true}))
        redirect_uri = orders_path
        if @payment.order
          @payment.update_attributes(currency: @payment.order.currency)
          redirect_uri = order_path(@payment.order_id)
        elsif @payment.registration
          @payment.update_attributes(currency: @payment.registration.currency)
          if @payment.registration.user
            format.html {redirect_to registrations_path}
          else
            format.html {redirect_to action: :show}
          end
        elsif @payment.user_gift
          @payment.update_attributes(currency: @payment.user_gift.currency)
          redirect_uri = user_gift_path(@payment.user_gift)
        end
        format.html {redirect_to redirect_uri}
      else
        format.html {render json: @payment.errors}
      end
    end
  end

  def show

  end

  private
    def payment_params
      if current_user
        params.require(:payment).permit(:id, :payment_type, :order_id, :registration_id, :user_gift_id, :wait, :amount, :pay_time, :identifier).merge({user_id: current_user.id})
      else
        params.require(:payment).permit(:id, :payment_type, :order_id, :registration_id, :user_gift_id, :wait, :amount, :pay_time, :identifier)
      end
    end

    def paypal_api_error(e)
      respond_to do |format|
        flash[:message] = e.response.details[0].long_message
        flash[:status] = 'danger'
        payment = Payment.where(token: params[:token]).all.first
        payment.destroy
        if payment.order
          format.html {redirect_to pay_order_path(payment.order)}
        elsif payment.registration
          format.html {redirect_to pay_registration_path(payment.registration)}
        elsif payment.user_gift
          format.html {redirect_to pay_user_gift_path(payment.user_gift)}
        end
      end
    end

    def set_payment
      @payment = Payment.where(id: params[:id], user_id: (current_user)? current_user.id : nil, completed: false).first
    end

    def remove_exists
      Payment.destroy_all(registration_id: payment_params[:registration_id])
      Payment.destroy_all(order_id: payment_params[:order_id])
      Payment.destroy_all(user_gift_id: payment_params[:user_gift_id])
    end
end
