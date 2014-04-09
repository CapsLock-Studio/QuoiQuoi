class HomeController < ApplicationController

  # GET /
  # GET /.json
  def index
    @slides = Slide.all.order(:sort)
    @products = Product.limit(6)
    @broadcasts = Broadcast.all.order(:sort)
  end

  # GET /home/style1
  def style1
    @slides = Slide.all.order(:sort)
  end

  # GET /home/style2
  def style2

  end
end
