class CreateCourseTypeTranslates < ActiveRecord::Migration
  def change
    create_table :course_type_translates do |t|
      t.references :locale, index: true
      t.references :course_type, index: true
      t.string :name

      t.timestamps
    end
  end
end
