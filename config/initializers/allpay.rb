require 'allpay'

AllPay.setup do |allpay|
  if Rails.env.production?
    allpay.merchant_id = '1064334'
    allpay.hash_key    = 'pfFZuH6agiuAZjag'
    allpay.hash_iv     = '9NyCYRX0OQU14XOs'
  else
    allpay.merchant_id = '2000132'
    allpay.hash_key    = '5294y06JbISpM5x9'
    allpay.hash_iv     = 'v77hoKGq4kWxNNIS'
  end
end
