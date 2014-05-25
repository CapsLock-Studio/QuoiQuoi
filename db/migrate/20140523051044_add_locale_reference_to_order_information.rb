class AddLocaleReferenceToOrderInformation < ActiveRecord::Migration
  def change
    add_reference :order_informations, :locale
  end
end
