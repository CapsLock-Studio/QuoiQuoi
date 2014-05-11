class RegistrationsController < ApplicationController
  before_action :authenticate_user!

  def index
    add_breadcrumb t('header.navigation.home'), :root_path
    add_breadcrumb t('registrations')

    @registrations = Registration.where(closed: false, user_id: current_user.id)
  end

  def close_index
    add_breadcrumb t('header.navigation.home'), :root_path
    add_breadcrumb '已結束課程'

    @registrations = Registration.where(closed: true, user_id: current_user.id)

    respond_to do |format|
      format.html {render action: :index}
    end
  end

  # GET /registration
  def new
    add_breadcrumb t('header.navigation.home'), :root_path
    add_breadcrumb t('register')

    course = Course.find(params[:course_id])
    @registration = course.registration.build
  end

  def create
    respond_to do |format|
      registration = Registration.new(registration_params.merge({user_id: current_user.id}))
      registration.subtotal = registration.attendance * registration.course.price

      if registration.save
        format.html {redirect_to pay_registration_path(registration)}
      else
        format.html {render json: registration.errors}
      end
    end
  end

  def show
    respond_to do |format|
      registration = Registration.where(id: params[:id], user_id: current_user.id).first
      #format.html {render course_path(registration.course)}
      format.html {}
    end
  end

  def pay_show
    add_breadcrumb t('header.navigation.home'), :root_path
    add_breadcrumb t('register'), :registrations_path
    add_breadcrumb t('payment')

    @registration = Registration.where(id: params[:id], user_id: current_user.id).first
    @payment = @registration.build_payment
  end

  private
    def registration_params
      params.require(:registration).permit(:attendance, :name, :phone, :course_id)
    end
end