class HomeController < ApplicationController

  # GET /
  # GET /.json
  def index
    respond_to do |format|
      @broadcasts = Broadcast.all.order(:sort)

      format.html do
        @slides = Slide.all.order(:sort)
        @products = Product.order(updated_at: :desc).limit(6)
      end

      format.rss do
        @courses = Course
        @products = Product.order(updated_at: :desc).limit(50)

        render layout: false
      end
    end
  end
end