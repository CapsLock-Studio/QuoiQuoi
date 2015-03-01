class AddNewReferenceToCourseOption < ActiveRecord::Migration
  def change
    add_reference :course_options, :course_option_group
  end
end
