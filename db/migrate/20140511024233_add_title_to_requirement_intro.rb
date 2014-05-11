class AddTitleToRequirementIntro < ActiveRecord::Migration
  def change
    add_column :requirement_intro_translates, :title, :string
    rename_column :requirement_intro_translates, :description, :content
  end
end
