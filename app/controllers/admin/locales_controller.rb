class Admin::LocalesController < AdminController
  authorize_resource

  before_action :set_locale, except: [:index, :create, :new]

  add_breadcrumb '首頁', :admin_root_path
  add_breadcrumb '語系列表', :admin_locales_path

  # GET /admin/locales
  # GET /admin/locales.json
  def index
    @locales = Locale.all
  end

  # GET /admin/locales/1
  # GET /admin/locales/1.json
  def show

  end

  # GET /admin/locales/new
  def new
    add_breadcrumb '新增語系'

    @locale = Locale.new
  end

  # GET /admin/locales/1/edit
  def edit
    add_breadcrumb '修改語系'
  end

  # POST /admin/locales
  # POST /admin/locales.json
  def create
    @locale = Locale.new(locale_params)

    respond_to do |format|
      if @locale.save
        format.html { redirect_to admin_locales_path, notice: '新增語系成功' }
        format.json { render json: Locale.all , status: :created }
      else
        format.html { render action: :new }
        format.json { render json: @locale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/locales
  # PATCH/PUT /admin/locales.json
  def update
    respond_to do |format|
      if @locale.update(locale_params)
        format.html { redirect_to admin_locales_path, notice: '修改語系成功' }
        format.json { render json: Locale.all, status: :created }
      else
        format.html { render action: :edit }
        format.json { render json: @locale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/locales
  # DELETE /admin/locales.json
  def destroy
    respond_to do |format|
      if @locale.destroy
        format.html { redirect_to admin_locales_path, notice: '刪除語系成功' }
        format.json { head :no_content }
      end
    end
  end

  private
    def locale_params
      params.require(:locale).permit(:lang, :name, :currency)
    end

    def set_locale
      @locale = Locale.find(params[:id])
    end
end
