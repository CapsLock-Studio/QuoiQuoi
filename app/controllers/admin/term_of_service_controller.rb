class Admin::TermOfServiceController < AdminController
  def show

  end

  def edit

  end

  def update
    params[:term_of_service].each do |term_of_service|
      $redis.set("terms_of_service:locale:#{term_of_service[1][:locale_id]}", term_of_service[1][:content])
    end

    redirect_to action: :show
  end
end
