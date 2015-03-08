class CreateRegistrationOptions < ActiveRecord::Migration
  def change
    create_table :registration_options do |t|
      t.references :registration, index: true
      t.references :course_option, index: true
      t.float :price

      t.timestamps
    end
  end
end
