class RemoveTitleFromRequirementAddTitleToRequirementtraslates < ActiveRecord::Migration
  def change
    remove_column :requirements, :title
    add_column :requirement_translates, :title, :string
  end
end
