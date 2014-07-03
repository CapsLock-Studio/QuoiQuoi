class AddCourseOptionRefernceToRegistration < ActiveRecord::Migration
  def change
    add_reference :registrations, :course_option, index: true
  end
end
