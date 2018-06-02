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
      $redis.set("remittance:locale:#{remittance_params[params][:locale_id]}:name", remittance_params[params][:name])
      $redis.set("remittance:locale:#{remittance_params[params][:locale_id]}:code", remittance_params[params][:code])
      $redis.set("remittance:locale:#{remittance_params[params][:locale_id]}:account", remittance_params[params][:account])
      $redis.set("remittance:locale:#{remittance_params[params][:locale_id]}:bank_name", remittance_params[params][:bank_name])
      $redis.set("remittance:locale:#{remittance_params[params][:locale_id]}:bank_address", remittance_params[params][:bank_address])
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
