class AddAddressAndBussinessHour < ActiveRecord::Migration
  def change
    add_column :contact_translates, :business_hour, :string
    add_column :contact_translates, :address, :string
  end
end
