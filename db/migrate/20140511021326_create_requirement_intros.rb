class CreateRequirementIntros < ActiveRecord::Migration
  def change
    create_table :requirement_intros do |t|
      t.attachment :image

      t.timestamps
    end
  end
end
