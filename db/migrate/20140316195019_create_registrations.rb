class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.references :course, index: true
      t.references :user, index: true
      t.boolean :accept

      t.timestamps
    end
  end
end
