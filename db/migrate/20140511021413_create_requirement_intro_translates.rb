class CreateRequirementIntroTranslates < ActiveRecord::Migration
  def change
    create_table :requirement_intro_translates do |t|
      t.references :requirement_intro, show: true
      t.string :description

      t.timestamps
    end
  end
end
