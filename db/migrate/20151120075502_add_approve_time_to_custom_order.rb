class AddApproveTimeToCustomOrder < ActiveRecord::Migration
  def change
    add_column :custom_orders, :approve_time, :datetime
    add_column :custom_orders, :cancel, :boolean, default: false
    add_column :custom_orders, :cancel_reason, :text
    add_column :custom_orders, :cancel_time, :datetime
  end
end
