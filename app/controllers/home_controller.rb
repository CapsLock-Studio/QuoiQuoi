class HomeController < ApplicationController
  # GET /
  # GET /.json
  def index
    @slides = Slide.all.order(:sort)
    @products = Product.order(created_at: :desc).limit(6)
    @broadcasts = Broadcast.all.order(:sort)
  end
end
