class AddTitleToRequirement < ActiveRecord::Migration
  def change
    add_column :requirements, :title, :string
  end
end
