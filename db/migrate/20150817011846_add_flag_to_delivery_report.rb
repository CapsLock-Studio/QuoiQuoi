class AddFlagToDeliveryReport < ActiveRecord::Migration
  def change
    add_column :orders, :delivery_report_handled, :boolean, default: false
    add_column :orders, :delivery_report_handled_time, :datetime
  end
end
