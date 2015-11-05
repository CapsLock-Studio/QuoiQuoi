class Admin::RemittancesController < AdminController
  authorize_resource

  def show
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
    remittance_params.each do |params|
      $redis.set("remittance:locale:#{params[1][:locale_id]}:name", params[1][:name])
      $redis.set("remittance:locale:#{params[1][:locale_id]}:code", params[1][:code])
      $redis.set("remittance:locale:#{params[1][:locale_id]}:account", params[1][:account])
      $redis.set("remittance:locale:#{params[1][:locale_id]}:bank_name", params[1][:bank_name])
      $redis.set("remittance:locale:#{params[1][:locale_id]}:bank_address", params[1][:bank_address])
    end
    redirect_to action: :show
  end

  def destroy
  end

  private
    def remittance_params
      params.require(:remittance)
    end
end
