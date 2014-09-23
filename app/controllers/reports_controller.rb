class ReportsController < ApplicationController
  # GET /reports
  def index
    @website_title = "#{t('report_remittance')} | #{@website_title}"
    @registrations = Registration.where(email: params[:email])
  end

  # GET /reports/new
  def new

  end
end