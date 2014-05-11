class Admin::RentIntrosController < AdminController
  authorize_resource

  before_action :set_rent_intro, except: [:index, :create, :new]

  def index
    @rent_intros = RentIntro.all.page(params[:page]).per(18)
  end

  def edit

  end

  def new
    @rent_intro = RentIntro.new

    Locale.all.each do |locale|
      @rent_intro.rent_intro_translates.build(locale_id: locale.id)
    end
  end

  def create
    @rent_intro = RentIntro.new(rent_intro_params)
    respond_to do |format|
      if @rent_intro.save
        format.html {redirect_to action: :index}
      else
        format.html {render json: @rent_intro.errors}
      end
    end
  end

  def update
    respond_to do |format|
      if @rent_intro.update_attributes(rent_intro_params)
        format.html {redirect_to action: :index}
      else
        format.html {render json: @rent_intro.errors}
      end
    end
  end

  def destroy
    respond_to do |format|
      if @rent_intro.destroy
        format.html {redirect_to action: :index}
      else
        format.html {render json: @rent_intro.errors}
      end
    end
  end

  private
    def set_rent_intro
      @rent_intro = RentIntro.find(params[:id])
    end

    def rent_intro_params
      params.require(:rent_intro).permit(:id, :image, rent_intro_translates_attributes: [:id, :locale_id, :rent_intro_id, :_destroy, :description])
    end
end
