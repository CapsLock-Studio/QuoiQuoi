class RemoveCouseTypeReference < ActiveRecord::Migration
  def change
    remove_reference :courses, :course_type
  end
end
