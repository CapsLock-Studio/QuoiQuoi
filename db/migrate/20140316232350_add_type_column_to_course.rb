class AddTypeColumnToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :course, :string
    add_reference :courses, :course_type, show: true
  end
end
