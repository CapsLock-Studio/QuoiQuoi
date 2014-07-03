class RegistrationsController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create, :pay_show]

  def index
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('registrations')

    @registrations = Registration.where(closed: false, email: current_user.email)
  end

  def close_index
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('course.past')

    @registrations = Registration.where(closed: true, email: current_user.email)

    respond_to do |format|
      format.html {render action: :index}
    end
  end

  # GET /registration
  def new
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('register')

    flash[:message] = nil

    @registration = Registration.new(registration_params)
  end

  def create
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('register')

    respond_to do |format|
      course = Course.find(registration_params[:course_id])
      translate = course.course_translates.where(locale_id: session[:locale_id]).first
      @registration = Registration.new(registration_params)

      if current_user
        @registration.email = current_user.email
        @registration.user_id = current_user.id
      end

      if course.popular >= (course.registrations.collect{|r| (r.payment && r.payment.completed?)? r.attendance : 0}.inject{|sum, attendance| sum + attendance}).to_i + @registration.attendance
        # if email has registered course can not register again
        if Registration.count(conditions: {email: registration_params[:email], course_id: @registration.course_id}) <= 0
          @registration.subtotal = @registration.attendance * translate.price
          @registration.locale_id = translate.locale.id
          @registration.currency = translate.locale.currency

          if @registration.save
            format.html {redirect_to pay_registration_path(@registration)}
          else
            format.html {render json: @registration.errors}
          end
        else
          flash[:message] = t('had_registered_hint')
          format.html {render action: :new}
        end
      else
        format.html {render json: 'Over registration max attendance.'}
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
      params.require(:registration).permit(:attendance, :email, :name, :phone, :course_id, :course_option_id)
    end
end