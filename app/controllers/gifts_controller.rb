class GiftsController < ApplicationController
  def index
    add_breadcrumb t('header.navigation.home'), root_path
    add_breadcrumb t('gift')

    @gifts = Gift.all
  end

  def show
    add_breadcrumb t('header.navigation.home'), root_path
    add_breadcrumb t('gift'), gifts_path
    add_breadcrumb t('product_detail')

    @gifts = Gift.where.not(id: params[:id])
    @user_gift = UserGift.new(gift_id: params[:id])
  end
end