class HomeController < ApplicationController
  # GET /
  # GET /.json
  def index
    @slides = Slide.all.order(:sort)
    @broadcasts = Broadcast.all.order(:sort)
    @tops = []
    Top.order(:sort).limit(6).each do |top|
      @tops << {image: top.image.url(:medium), link: top.top_translates.where(locale_id: session[:locale_id]).first.link}
    end

    if @tops.length < 6
      remain = (6 - @tops.length) / 2
      Product.limit(remain).order(created_at: :desc).each do |product|
        link_path = product_path(product)
        unless product.product_type.nil?
          link_path = product_type_product_path(product.product_type, product)
        end
        @tops << {image: product.image.url(:medium), link: link_path}
      end
      Course.limit(remain).order(created_at: :desc).each do |course|
        @tops << {image: course.image.url(:medium), link: course_path(course, month: course.time.strftime('%m'))}
      end
    end
  end
end