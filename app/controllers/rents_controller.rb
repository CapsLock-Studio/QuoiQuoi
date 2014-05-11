class RentsController < ApplicationController
  # GET /rents
  def show
    add_breadcrumb t('header.navigation.home'), :root_path
    add_breadcrumb t('header.navigation.rent')

    @rent_infos = RentInfo.all.order(:id)
    @rent_intros = RentIntro.all.order(:id)
    @rent_info_images = RentInfoImage.all.order(:id)
  end

  # GET /rents/main
  def main

  end

  # GET /rents/big_slide
  def big_slide

  end

  # GET /rents/slide
  def slide

  end
end
