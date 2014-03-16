class CoursesController < ApplicationController
  # GET /course
  def index
    @courses = Course.all.page(params[:page]).per(12)
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
