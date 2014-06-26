class RegistrationsController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create, :pay_show]

  def index
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('registrations')

    @registrations = Registration.where(closed: false, user_id: current_user.id)
  end

  def close_index
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('course.past')

    @registrations = Registration.where(closed: true, user_id: current_user.id)

    respond_to do |format|
      format.html {render action: :index}
    end
  end

  # GET /registration
  def new
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('register')

    course = Course.find(params[:course_id])
    @registration = course.registrations.build
  end

  def create
    respond_to do |format|
      registration = Registration.new(registration_params)
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
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('register'), :registrations_path
    add_breadcrumb t('payment')

    @registration = Registration.find(params[:id])
    @payment = @registration.build_payment
  end

  private
    def registration_params
      if current_user
        params.require(:registration).permit(:attendance, :name, :phone, :course_id).merge({user_id: current_user.id, email: current_user.email})
      else
        params.require(:registration).permit(:attendance, :email, :name, :phone, :course_id)
      end
    end
end