class Admin::RegistrationPaymentsController < AdminController
  before_action :set_registration_payment, only: [:update, :show]

  def show
    render layout: false
  end

  def update
    if sanitize_params[:cancel]
      @registration_payment.cancel = true
      @registration_payment.cancel_time = Time.now
      @registration_payment.cancel_reason = sanitize_params[:cancel_reason]
    elsif sanitize_params[:refund]
      @registration_payment.refunded = true
      @registration_payment.refunded_time = Time.now
    end

    @registration_payment.save!

    flash[:id] = @registration_payment.registration.id
    flash[:status] = sanitize_params

    redirect_to :back
  end

  private
  def set_registration_payment
    @registration_payment = RegistrationPayment.find(params[:id])
  end

  def sanitize_params
    params.permit(:cancel, :cancel_reason, :refund)
  end
end