class AddDefaultOptionsForCustomOrder < ActiveRecord::Migration
  def change
    add_column :past_work_translates, :order_type, :string
    add_column :past_work_translates, :style, :string
    add_column :past_work_translates, :size, :string
    add_column :past_work_translates, :materials, :string
  end
end
