xml.instruct! :xml, version: '1.0'
xml.rss version: '2.0' do
  xml.channel do
    xml.title 'quoiquoi 布知道'
    xml.description '我們專注於替每位客戶打造屬於個人的手作包，quoiquoi獨一無二的手作包能完美的陪襯出你的個人特質'
    xml.language Locale.find(session[:locale_id]).lang
    xml.pubDate Product.last.updated_at.to_s(:rfc822)
    xml.link products_url

    @products.each do |product|
      translate = product.product_translates.where(locale_id: session[:locale_id]).first
      xml.item do
        xml.title translate.name
        xml.description "<![CDATA[<img src=\"http://udn.com/NEWS/MEDIA/8768801-3466739.jpg\"><div >#{translate.description}</div>]]>".html_safe
        xml.pubDate product.updated_at.to_s(:rfc822)
        xml.link product_url(product)
        xml.guid product_url(product)
        xml.media :thumbnail, url: asset_url(product.image.url(:thumb)), type: 'image/jpeg'
      end
    end
  end
end