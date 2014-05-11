class CreateRequirementIntroTranslates < ActiveRecord::Migration
  def change
    create_table :requirement_intro_translates do |t|
      t.references :requirement_intro, index: true
      t.string :description

      t.timestamps
    end
  end
end
