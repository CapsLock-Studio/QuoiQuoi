atom_feed({'xmlns:app' => 'http://www.w3.org/2007/app',
           'xmlns:openSearch' => 'http://a9.com/-/spec/opensearch/1.1/'}) do |feed|
  feed.title('quoi quoi 布知道')
  feed.updated(Course.last.created_at)

  @courses.each do |course|
    translate = course.course_translates.where(locale_id: session[:locale_id]).first
    if translate.price
      feed.entry(course) do | entry|
        entry.title translate.name
        entry.published course.created_at
        entry.updated course.updated_at
        entry.link course_url(course)
        entry.guid course_url(course)
        entry.content "<img src=#{asset_url(course.image.url(:medium))} width='300', height='225'>#{simple_format(translate.description)}#{link_to "#{t('detail')}...", course_url(course)}", :type => 'html'
      end
    end
  end
end
