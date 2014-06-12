class CreateCourseImages < ActiveRecord::Migration
  def change
    create_table :course_images do |t|
      t.references :course, show: true
      t.attachment :image

      t.timestamps
    end
  end
end
