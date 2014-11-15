class ModifyPastWorkTranslateDescriptionToText < ActiveRecord::Migration
  def change
    change_column :past_work_translates, :description, :text
  end
end
