class Admin::ShippingFeesController < AdminController
  authorize_resource

  before_action :set_shipping_fee, except: [:index, :new, :create]

  add_breadcrumb '首頁', :admin_root_path
  add_breadcrumb '國家運費資訊管理', :admin_shipping_fees_path

  # GET /admin/shipping_fees
  # GET /admin/shipping_fees.json
  def index
    @shipping_fees = ShippingFee.all
  end

  # GET /admin/shipping_fees/1
  # GET /admin/shipping_fees/1.json
  def show

  end

  # GET /admin/shipping_fees/new
  def new
    add_breadcrumb '新增區域運費資訊'

    @shipping_fee = ShippingFee.new

    Locale.all.order(id: :desc).each do |locale|
      @shipping_fee.shipping_fee_translates.build(locale_id: locale.id)
    end
  end

  # GET /admin/shipping_fees/1/edit
  def edit
    add_breadcrumb '修改區域運費資訊'
  end

  # POST /admin/shipping_fees
  # POST /admin/shipping_fees.json
  def create
    @shipping_fee = ShippingFee.new(shipping_fee_params)

    respond_to do |format|
      if @shipping_fee.save
        format.html { redirect_to action: :index, notice: 'Create Success.' }
        format.json { render action: :index, status: :created }
      else
        format.html { render action: :new }
        format.json { render json: @shipping_fee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/shipping_fees/1
  # PATCH/PUT /admin/shipping_fees/1.json
  def update
    respond_to do |format|
      if @shipping_fee.update_attributes(shipping_fee_params)
        format.html { redirect_to action: :index, notice: 'Update Success.' }
        format.json { render action: :index, status: :accepted }
      else
        format.html { render action: :edit }
        format.json { render json: @shipping_fee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/shipping_fees/1
  # DELETE /admin/shipping_fees/1.json
  def destroy
    respond_to do |format|
      if @shipping_fee.destroy
        format.html { redirect_to action: :index }
      end
    end
  end

  private
  def set_shipping_fee
    @shipping_fee = ShippingFee.find(params[:id])
  end

  def shipping_fee_params
    params.require(:shipping_fee).permit(:id, :area, shipping_fee_translates_attributes: [:id, :locale_id, :fee, :free_condition])
  end
end
