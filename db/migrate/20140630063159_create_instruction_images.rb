class CreateInstructionImages < ActiveRecord::Migration
  def change
    create_table :instruction_images do |t|
      t.references :instruction, index: true
      t.attachment :image

      t.timestamps
    end
  end
end
