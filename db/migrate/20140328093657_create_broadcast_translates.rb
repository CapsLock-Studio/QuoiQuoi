class CreateBroadcastTranslates < ActiveRecord::Migration
  def change
    create_table :broadcast_translates do |t|
      t.references :broadcast, show: true
      t.string :notification

      t.timestamps
    end
  end
end
