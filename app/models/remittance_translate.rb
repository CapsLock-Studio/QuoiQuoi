class RemittanceTranslate < ActiveRecord::Base
  belongs_to :locale
  belongs_to :remittance
end