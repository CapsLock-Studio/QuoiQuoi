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

      RegistrationMailer.cancel_notification(@registration_payment.registration_id).deliver_later
    elsif sanitize_params[:refund]
      @registration_payment.refunded = true
      @registration_payment.refunded_time = Time.now
    elsif sanitize_params[:paid]
      @registration_payment.completed = true
      @registration_payment.completed_time = Time.now

      remittance_report = @registration_payment.registration_remittance_reports.build
      remittance_report.amount = @registration_payment.amount
      remittance_report.account = '現場付款'
      remittance_report.date = Time.now
      remittance_report.confirm = true
      remittance_report.save!

      RegistrationMailer.completed_confirmation(@registration_payment.registration_id).deliver_later
    end

    @registration_payment.save!

    flash[:id] = @registration_payment.registration.id
    flash[:status] = sanitize_params

    redirect_to admin_course_registrations_path(@registration_payment.registration.course_id, @registration_payment.registration_id)
  end

  private
  def set_registration_payment
    @registration_payment = RegistrationPayment.find(params[:id])
  end

  def sanitize_params
    params.permit(:cancel, :cancel_reason, :refund, :paid)
  end
end