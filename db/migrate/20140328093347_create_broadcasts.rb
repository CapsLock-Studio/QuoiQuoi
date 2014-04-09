class CreateBroadcasts < ActiveRecord::Migration
  def change
    create_table :broadcasts do |t|

      t.timestamps
    end
  end
end
