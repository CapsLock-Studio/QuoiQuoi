class AddDeliveryReportPropertyToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :delivery_report, :boolean, default: false
    add_column :orders, :delivery_report_time, :datetime
    add_column :orders, :delivery_report_message, :text
  end
end
