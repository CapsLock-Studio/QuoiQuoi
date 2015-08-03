require 'allpay'

AllPay.setup do |allpay|
  if Rails.env.production?
    allpay.merchant_id = 'write your production merchant_id'
    allpay.hash_key    = 'write your production hash_key'
    allpay.hash_iv     = 'write your production hash_iv'
  else
    allpay.merchant_id = '2000132'
    allpay.hash_key    = '5294y06JbISpM5x9'
    allpay.hash_iv     = 'v77hoKGq4kWxNNIS'
  end
end