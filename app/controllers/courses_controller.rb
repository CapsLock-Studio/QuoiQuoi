class CoursesController < ApplicationController
  # GET /course
  def index
    respond_to do |format|
      format.html do
        if params[:month].blank?
          redirect_to courses_path(month: Date.today.month)
        end
        @courses = Course.by_month(params[:month]).page(params[:page]).per(12)
      end

      format.json do
        @courses = Course.all
      end
    end

  end

  def calendar

  end

  # GET /course/1
  def show

  end

  # GET /course/1/edit
  def edit

  end

  # GET /course/new
  def new

  end

  # POST /course
  def create

  end

  # PATCH/PUT /course/1
  def update

  end

  # DELETE /course/1
  def destroy

  end
end
