class RequirementIntroTranslate < ActiveRecord::Base
  belongs_to :requirement_intro
  belongs_to :locale
end
