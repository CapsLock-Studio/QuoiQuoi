class RentIntroTranslate < ActiveRecord::Base
  belongs_to :rent_intro
  belongs_to :locale
end
