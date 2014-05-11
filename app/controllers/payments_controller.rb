# Bad code, it should be separate, like order_payment, registration_payment and gift_payment
# But i don't want to modify this part right now.
# This is in the to-do list to reconstruct next time.

class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_payment, only: [:edit, :update]
  rescue_from Paypal::Exception::APIError, with: :paypal_api_error

  def create
    respond_to do |format|
      payment = Payment.new(payment_params.merge({user_id: current_user.id}))
      if payment_params[:wait] == 'true'
        payment.save!(validate: false)
        format.html {redirect_to edit_payment_path(payment)}
      else
        amount = 0

        if payment.order
          amount = payment.order.subtotal
        elsif payment.registration
          amount = payment.registration.subtotal
        elsif payment.user_gift
          amount = payment.user_gift.gift.quota
        end

        #format.html {render json: payment}

        payment.setup!(amount, success_payments_url, cancel_payments_url)
        format.html {redirect_to payment.redirect_uri}
      end
    end
  end

  def success
    payment = Payment.where(token: params[:token]).all.first

    respond_to do |format|
      payment.complete!(params[:PayerID])
      if payment.order
        format.html {redirect_to orders_path}
      elsif payment.registration
        format.html {redirect_to registrations_path}
      elsif payment.user_gift
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
    add_breadcrumb t('header.navigation.home'), :root_path
    add_breadcrumb t('order_in_trading'), :orders_path
    add_breadcrumb t('report_remittance').upcase
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
          redirect_uri = order_path(@payment.order_id)
        elsif @payment.registration
          redirect_uri = registrations_path
        elsif @payment.user_gift
          redirect_uri = user_gift_path(@payment.user_gift)
        end
        format.html {redirect_to redirect_uri}
      else
        format.html {render json: @payment.errors}
      end
    end
  end

  private
    def payment_params
      params.require(:payment).permit(:id, :payment_type, :order_id, :registration_id, :user_gift_id, :wait, :amount, :pay_time, :identifier)
    end

    def paypal_api_error(e)
      respond_to do |format|
        format.html {render json: e.response.details}
      end
    end

    def set_payment
      @payment = Payment.where(id: params[:id], user_id: current_user.id, completed: false).first
    end
end
