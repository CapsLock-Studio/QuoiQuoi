class Admin::BoardController < AdminController
  def index
    add_breadcrumb '首頁', :admin_root_path
    add_breadcrumb '訊息留言板'

    @contact_us = ContactUs.all
  end

  def show
    add_breadcrumb '首頁', :admin_root_path
    add_breadcrumb '訊息留言板', :admin_board_index_path
    add_breadcrumb '詳細訊息內容'

    @contact_us = ContactUs.find(params[:id])
  end

  def destroy
    @contact_us = ContactUs.find(params[:id])
    if @contact_us.destroy
      redirect_to admin_board_index_path
    else
      render json: @contact_us.errors
    end
  end
end
