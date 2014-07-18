atom_feed({'xmlns:app' => 'http://www.w3.org/2007/app',
           'xmlns:openSearch' => 'http://a9.com/-/spec/opensearch/1.1/'}) do |feed|
  feed.title('quoi quoi 布知道')
  feed.updated(Product.last.created_at)

  @products.each do |product|
    translate = product.product_translates.where(locale_id: session[:locale_id]).first
    if translate.price
      feed.entry(product) do | entry|
        entry.title translate.name
        entry.published product.created_at
        entry.updated product.updated_at
        entry.link product_url(product)
        entry.guid product_url(product)
        entry.content "<img src=#{asset_url(product.image.url(:medium))} width='300', height='225'>#{simple_format(translate.description)}#{link_to "#{t('detail')}...", product_url(product)}", :type => 'html'
      end
    end
  end
end
