class ChangeProductOptionStructure < ActiveRecord::Migration
  def change
    add_reference :product_options, :product_option_group
  end
end
