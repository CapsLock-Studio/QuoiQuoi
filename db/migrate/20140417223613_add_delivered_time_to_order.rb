class AddDeliveredTimeToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :delivered_time, :datetime
  end
end
