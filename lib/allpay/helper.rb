module AllPay
  module Helper
    def self.check_mac_value(fields)

      # First:  Sort form data by field key, add allpay HashKey to front and HashIV to end.
      # Second: Urlencode string and downcase it.
      # Thrid:  MD5 encode and return the result in upcase.
      raw_data = fields.sort.map{|field, value|
        "#{field}=#{value}" if field!='utf8' && field!='authenticity_token' && field!='commit'
      }.join('&')

      Digest::MD5.hexdigest(CGI::escape("HashKey=#{AllPay.hash_key}&#{raw_data}&HashIV=#{AllPay.hash_iv}").downcase).upcase

      # HashKey=5294y06JbISpM5x9&ChoosePayment=CVS&ChooseSubPayment=FAMILY&ItemName=測試 x 2#測試找字看看 x 1#測試 x 1&MerchantID=2000132&MerchantTradeDate=2015-03-23 04:50:41&MerchantTradeNo=ORDER_361&PaymentType=aio&ReturnURL=http://localhost:3000/order_payment_callback/cvs_family&TotalAmount=6510.0&TradeDesc=quoi quoi 布知道&HashIV=v77hoKGq4kWxNNIS
    end
  end
end