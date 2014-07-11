class Admin::BroadcastsController < AdminController
  before_action :set_broadcast, except: [:index, :new, :create, :sort]

  # GET /admin/broadcasts
  def index
    @broadcasts = Broadcast.all
  end

  # GET /admin/broadcasts/new
  def new
    @broadcast = Broadcast.new

    Locale.all.each do |locale|
      @broadcast.broadcast_translates.build(locale_id: locale.id)
    end
  end

  # GET /admin/broadcasts/1/edit
  def edit

  end

  # POST /admin/broadcasts
  def create
    params = broadcast_params.merge(sort: 1)

    broadcasts = Broadcast.order(:sort)

    unless broadcasts.last.nil?
      params[:sort] = (broadcasts.last.sort.to_i + 1)
    end

    @broadcast = Broadcast.new(params)

    respond_to do |format|
      #format.html {render json: broadcast_params}
      if @broadcast.save
        format.html {redirect_to action: :index, notice: 'Create Success.'}
      else
        format.html {render action: :index}
      end
    end
  end

  # PUT/PATCH /admin/broadcasts/1
  def update
    respond_to do |format|
      if @broadcast.update(broadcast_params)
        format.html {redirect_to action: :index}
      else
        format.html {render action: :edit}
      end
    end
  end

  # DELETE /admin/broadcasts/1
  def destroy
    respond_to do |format|
      if @broadcast.destroy
        format.html {redirect_to action: :index}
      end
    end
  end

  # PUT /admin/broadcasts/sort
  def sort
    respond_to do |format|
      #format.html {render json: update_params}
      slides = Broadcast.update(update_params[:broadcasts].keys, update_params[:broadcasts].values).reject{|p| p.errors.empty?}
      if slides.empty?
        format.html {redirect_to action: :index, sorted: true}
      end
    end
  end

  private
    def broadcast_params
      params.require(:broadcast).permit(:id, :sort, broadcast_translates_attributes: [:id, :locale_id, :link, :notification])
    end

    def set_broadcast
      @broadcast = Broadcast.find(params[:id])
    end

    def update_params
      params.permit(broadcasts: [:id, :sort])
    end
end
