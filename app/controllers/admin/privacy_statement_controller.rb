class Admin::PrivacyStatementController < AdminController
  def show
  end

  def edit

  end

  def create

  end

  def update
    params[:privacy_statement].each do |privacy_statement|
      $redis.set("privacy_statement:locale:#{privacy_statement[1][:locale_id]}", privacy_statement[1][:content])
    end

    redirect_to action: :show
  end

  def destroy

  end
end
