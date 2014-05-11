class GiftTranslate < ActiveRecord::Base
  belongs_to :gift
  belongs_to :locale
end
