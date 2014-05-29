class AboutController < ApplicationController
  def show
    add_breadcrumb t('header.navigation.home'), :root_path
    add_breadcrumb t('header.navigation.about_us')

    @designers = Designer.all
    @introduce_image_slides = IntroduceImageSlide.all
    @introduce_youtubes = IntroduceYoutube.all
  end
end
