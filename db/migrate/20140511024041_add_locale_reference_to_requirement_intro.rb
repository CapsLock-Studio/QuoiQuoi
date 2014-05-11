class AddLocaleReferenceToRequirementIntro < ActiveRecord::Migration
  def change
    add_reference :requirement_intro_translates, :locale, index: true
  end
end
