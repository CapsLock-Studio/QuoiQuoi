class CreateRentInfos < ActiveRecord::Migration
  def change
    create_table :rent_infos do |t|

      t.timestamps
    end
  end
end
