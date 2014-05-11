class Admin::DesignersController < AdminController
  before_action :set_designer, except: [:index, :create, :new]

  def index
    @designers = Designer.all
  end

  def show

  end

  def new
    @designer = Designer.new
    Locale.all.each do |locale|
      @designer.designer_translates.build(locale_id: locale.id)
    end
  end

  def edit

  end

  def create
    @designer = Designer.new(designer_params)
    respond_to do |format|
      if @designer.save
        format.html {redirect_to action: :index}
      else
        format.html {render json: @designer.errors}
      end
    end
  end

  def update

  end

  def destroy
    respond_to do |format|
      if @designer.destroy
        format.html {redirect_to action: :index}
      else
        format.html {render json: @designer.errors}
      end
    end
  end

  private
    def set_designer
      @designer = Designer.find(params[:id])
    end

    def designer_params
      params.require(:designer).permit(:id, :photo, designer_translates_attributes: [:id, :designer_id, :_destroy, :name, :introduction, :locale_id])
    end
end
