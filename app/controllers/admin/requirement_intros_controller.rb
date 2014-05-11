class Admin::RequirementIntrosController < AdminController
  authorize_resource

  before_action :set_requirement_intro

  def show
  end

  def new
    unless @requirement_intro
      @requirement_intro = RequirementIntro.new
      Locale.all.each do |locale|
        @requirement_intro.requirement_intro_translates.build(locale_id: locale.id)
      end
    end
  end

  def edit

  end

  def create
    unless @requirement_intro
      @requirement_intro = RequirementIntro.new(requirement_intro_params)
      respond_to do |format|
        if @requirement_intro.save
          format.html {redirect_to action: :show}
        else
          format.html {render action: :new, status: :unprocessable_entity}
        end
      end
    end
  end

  def update
    respond_to do |format|
      if @requirement_intro.update_attributes(requirement_intro_params)
        format.html {redirect_to action: :show}
      else
        format.html {render action: :edit}
      end
    end
  end

  def destroy

  end

  private
  def requirement_intro_params
    params.require(:requirement_intro).permit(:id, :image, requirement_intro_translates_attributes: [:id, :requirement_intro_id, :title, :content, :locale_id])
  end
  def set_requirement_intro
    begin
      @requirement_intro = RequirementIntro.find(1)
    rescue ActiveRecord::RecordNotFound
      @requirement_intro = nil
    end
  end
end
