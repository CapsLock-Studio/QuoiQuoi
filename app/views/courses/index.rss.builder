xml.instruct! :xml, version: '1.0'
xml.rss version: '2.0', 'xmlns:media' => 'http://search.yahoo.com/mrss/', 'xmlns:atom' => 'http://www.w3.org/2005/Atom' do
  xml.channel do
    xml.title 'quoiquoi 布知道'
    xml.description t('rss.course.title')
    xml.language session[:locale]
    xml.pubDate Course.last.created_at.to_s(:rfc822)
    xml.link products_url

    @courses.each do |course|
      translate = course.course_translates.where(locale_id: session[:locale_id]).first
      xml.item do
        xml.title translate.name
        xml.description translate.description.gsub(/\n/, ' ').gsub(/\r/, ' ')
        xml.pubDate course.time.to_s(:rfc822)
        xml.link course_url(course)
        xml.guid course_url(course)
        xml.media :thumbnail, width: 100, height: 75, url: asset_url(course.image.url(:thumb))
      end
    end
  end
end