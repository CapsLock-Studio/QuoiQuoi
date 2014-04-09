class OrdersController < ApplicationController
  before_action :set_order, except: [:index, :new]

  def index

  end

  def new
    set_breadcrumbs

    add_breadcrumb I18n.t('header.navigation.order_request')
  end

  # GET /orders/1
  def show
    respond_to do |format|
      case @order.verified
        when true
          format.html {render 'status'}
        when false
          # wait web holder check paid
          format.html {render 'vertify'}
        else
          @subtotal = []
          format.html {render 'show'}
      end
    end
  end

  # PUT/PATCH /orders/1
  def update

  end

  private
    def set_breadcrumbs
      add_breadcrumb I18n.t('header.navigation.home'), :root_path
      add_breadcrumb I18n.t('header.navigation.shop'), :products_path
    end

    def set_order
      @order = Order.find(params[:id])
    end
end
