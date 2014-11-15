atom_feed({'xmlns:app' => 'http://www.w3.org/2007/app',
           'xmlns:openSearch' => 'http://a9.com/-/spec/opensearch/1.1/'}) do |feed|
  feed.title(@website_title)
  feed.updated(Product.last.created_at)

  @products.each do |product|
    feed.entry(product) do | entry|
      entry.title product.product_translate.name
      entry.published product.created_at
      entry.updated product.updated_at
      entry.link product_url(product)
      entry.guid product_url(product)
      entry.content "<img src=#{asset_url(product.image.url(:medium))} width='300', height='225'>#{simple_format(product.product_translate.description)}#{link_to "#{t('detail')}...", product_url(product)}", :type => 'html'
    end
  end
end
