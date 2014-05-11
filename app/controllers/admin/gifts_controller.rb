class Admin::GiftsController < AdminController
  authorize_resource

  before_action :set_gift, except: [:index, :create, :new]
  add_breadcrumb '首頁', :root_path
  add_breadcrumb '禮品券管理', :gifts_path

  def index
    @gifts = Gift.all
  end

  def new
    add_breadcrumb '新增禮品券'

    @gift = Gift.new

    Locale.all.each do |locale|
      @gift.gift_translates.build(locale: locale)
    end
  end

  def edit
    add_breadcrumb '修改禮品券'
  end

  def create
    @gift = Gift.new(gift_params)

    respond_to do |format|
      if @gift.save
        format.html {redirect_to action: :index}
      else
        format.html {render action: :new}
      end
    end
  end

  def update
    respond_to do |format|
      if @gift.update_attributes(gift_params)
        format.html {redirect_to action: :index}
      else
        format.html {render action: :edit}
      end
    end
  end

  def destroy
    respond_to do |format|
      if @gift.destroy
        format.html {redirect_to action: :index}
      else
        format.html {render json: @gift.errors}
      end
    end
  end

  private
    def gift_params
      params.require(:gift).permit(:id, :quota, :image, gift_translates_attributes: [:id, :locale_id, :name, :description])
    end

    def set_gift
      @gift = Gift.find(params[:id])
    end
end
