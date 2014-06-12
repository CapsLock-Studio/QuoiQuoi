class RentsController < ApplicationController
  # GET /rents
  def show
    add_breadcrumb t('home'), :root_path
    add_breadcrumb t('rent')

    @rent_infos = RentInfo.all.order(:id)
    @rent_intros = RentIntro.all.order(:id)
    @rent_info_images = RentInfoImage.all.order(:id)
    @contact_us = ContactUs.new
  end
end
