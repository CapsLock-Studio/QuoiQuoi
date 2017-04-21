class RemittanceTranslate < ApplicationRecord
  belongs_to :locale
  belongs_to :remittance
end