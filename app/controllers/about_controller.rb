class AboutController < ApplicationController
  def show

    if flash[:status] == 'warning'
      flash[:message] = nil
    end

    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('about_us')

    @website_title = "#{t('about_us')} | #{@website_title}"
    @designers = Designer.all
    @introduce_image_slides = IntroduceImageSlide.all
    @introduce_youtubes = IntroduceYoutube.all
    @contact_us = ContactUs.new
    @faqs = Faq.where(locale_id: session[:locale_id]).order(:id)
  end
end
