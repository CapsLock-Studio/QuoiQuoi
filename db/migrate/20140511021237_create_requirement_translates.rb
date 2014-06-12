class CreateRequirementTranslates < ActiveRecord::Migration
  def change
    create_table :requirement_translates do |t|
      t.references :requirement, show: true
      t.string :description

      t.timestamps
    end
  end
end
