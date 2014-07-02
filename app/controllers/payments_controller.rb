# Bad code, it should be separate, like order_payment, registration_payment and gift_payment
# But i don't want to modify this part right now.
# This is in the to-do list to reconstruct next time.

class PaymentsController < ApplicationController
  before_action :set_payment, only: [:edit, :update]
  rescue_from Paypal::Exception::APIError, with: :paypal_api_error

  def create
    respond_to do |format|
      payment = Payment.new(payment_params)

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
        amount = gift.quota
        currency = payment.user_gift.currency
      end

      # when gift card cause price decrease to zero, set it pay complete
      if amount == 0
        if payment.update_attributes(completed: true, currency: currency)
          if payment.order

            # send mail to remind order complete
            OrderMailer.remind(payment.order, "#{request.protocol}#{request.host_with_port}").deliver
            format.html {redirect_to order_path(payment.order_id)}
          elsif payment.registration

            # send mail to remind registration
            RegistrationMailer.remind(payment.registration, "#{request.protocol}#{request.host_with_port}").deliver
            format.html {redirect_to registrations_path}
          end
        else
          format.html {render json: @payment.errors}
        end

        # payment need manual check
      elsif payment_params[:wait] == 'true'
        payment.save!(validate: false)
        if payment.registration

          # send mail to remind that if the remittance not complete in three days, it will discard auto
          RegistrationMailer.remittance_remind(payment.registration, "#{request.protocol}#{request.host_with_port}").deliver
        elsif payment.order
          OrderMailer.remittance_remind(payment.order, "#{request.protocol}#{request.host_with_port}").deliver
        elsif payment.user_gift
          UserGiftMailer.remittance_remind(payment.user_gift).deliver
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
    payment = Payment.where(token: params[:token]).all.first

    respond_to do |format|
      payment.complete!(params[:PayerID])
      if payment.order
        OrderMailer.remind(payment.order, session[:locale_id], "#{request.protocol}#{request.host_with_port}").deliver
        format.html {redirect_to orders_path}
      elsif payment.registration
        RegistrationMailer.remind(payment.registration, session[:locale_id], "#{request.protocol}#{request.host_with_port}").deliver
        if payment.registration.user
          format.html {redirect_to registrations_path}
        else
          format.html {redirect_to action: :show}
        end
      elsif payment.user_gift
        UserGiftMailer.completed_remind(payment.user_gift).deliver
        format.html {redirect_to user_gifts_path}
      end
    end
  end

  def cancel
    payment = Payment.where(token: params[:token]).all.first

    respond_to do |format|
      payment.cancel!
      if payment.order
        format.html {redirect_to close_orders_path}
      elsif payment.registration
        format.html {redirect_to close_registrations_path}
      else
        format.html {render json: 'Paypal payment error!'}
      end
    end
  end

  def edit
    begin
      @remittance_translate = Remittance.find(1).remittance_translates.where(locale_id: session[:locale_id]).first
    rescue ActiveRecord::RecordNotFound
      @remittance_translate = nil
    end
  end

  def update
    respond_to do |format|
      #format.html {render json: @payment}
      if @payment.update_attributes(payment_params.merge({token: Base64.encode64("#{Time.now}#{(0..3).map{('a'..'z').to_a[rand(26)]}.join}")}))
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
        format.html {render json: e.response.details}
      end
    end

    def set_payment
      @payment = Payment.where(id: params[:id], user_id: (current_user)? current_user.id : nil, completed: false).first
    end
end
