class CreateCourseTypes < ActiveRecord::Migration
  def change
    create_table :course_types do |t|

      t.timestamps
    end
  end
end
