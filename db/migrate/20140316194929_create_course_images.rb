class CreateCourseImages < ActiveRecord::Migration
  def change
    create_table :course_images do |t|
      t.attachment :image

      t.timestamps
    end
  end
end
