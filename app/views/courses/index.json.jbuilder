json.array!(@courses) do |course|
    json.title course.course_translates.where(locale_id: session[:locale_id]).first.name
    json.start course.time.strftime('%Y-%m-%d')
    json.url course_path(course, month: course.time.month)
end