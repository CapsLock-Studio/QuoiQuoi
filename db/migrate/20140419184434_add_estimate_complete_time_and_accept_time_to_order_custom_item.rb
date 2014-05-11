class AddEstimateCompleteTimeAndAcceptTimeToOrderCustomItem < ActiveRecord::Migration
  def change
    add_column :order_custom_items, :estimate_complete_time, :datetime
    add_column :order_custom_items, :accept_time, :datetime
  end
end
