class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :user, show: true
      t.string :content
      t.boolean :admin, default: false

      t.timestamps
    end
  end
end
