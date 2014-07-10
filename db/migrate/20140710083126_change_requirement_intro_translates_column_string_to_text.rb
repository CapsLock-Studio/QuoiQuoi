class ChangeRequirementIntroTranslatesColumnStringToText < ActiveRecord::Migration
  def change
    change_column :requirement_intro_translates, :content, :text
  end
end
