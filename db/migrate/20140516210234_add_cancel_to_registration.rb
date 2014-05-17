class AddCancelToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :canceled, :boolean, default: false
    add_column :registrations, :canceled_time, :datetime
  end
end
