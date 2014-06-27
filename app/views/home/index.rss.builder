xml.instruct! :xml, version: '1.0'
xml.rss version: '2.0', 'xmlns:media' => 'http://search.yahoo.com/mrss/', 'xmlns:atom' => 'http://www.w3.org/2005/Atom' do
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
        xml.description translate.description.gsub(/\n/, ' ').gsub(/\r/, ' ')
        xml.pubDate product.updated_at.to_s(:rfc822)
        xml.link product_url(product)
        xml.guid product_url(product)
        xml.media :thumbnail, width: 100, height: 75, url: asset_url(product.image.url(:thumb))
      end
    end
  end
end