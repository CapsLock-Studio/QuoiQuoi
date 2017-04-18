class GiftTranslate < ApplicationRecord
  belongs_to :gift
  belongs_to :locale
end
