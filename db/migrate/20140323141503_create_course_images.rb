class CreateCourseImages < ActiveRecord::Migration
  def change
    create_table :course_images do |t|
      t.references :course, index: true
      t.attachment :image

      t.timestamps
    end
  end
end
