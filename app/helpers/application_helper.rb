module ApplicationHelper
  def nav_item(link, options = nil, &block)
    options ||= {}
    options[:class] ||= ''

    if options[:rule].nil?
      # set up active
      options[:class] << ' active' if current_page?(link)
    else
      options[:class] << ' active' if request.env['PATH_INFO'] =~ options[:rule]
    end

    if block_given?
      content_tag_string(:li, capture(&block), options, true)
    else
      content_tag_string(:li, nil, options, true)
    end
  end

  def nav_item_with_resource(link, options = nil, resource = nil, &block)
    options ||= {}
    options[:class] ||= ''

    if !resource.nil? && can?(:read, resource)
      if options[:rule].nil?
        # set up active
        options[:class] << ' active' if current_page?(link)
      else
        options[:class] << ' active' if request.env['PATH_INFO'] =~ options[:rule]
      end

      if block_given?
        content_tag_string(:li, capture(&block), options, true)
      else
        content_tag_string(:li, nil, options, true)
      end
    end
  end

  def lang_nav_item(language, &block)
    options ||= {}
    options[:class] = 'active' if I18n.locale == language.to_sym

    if block_given?
      content_tag_string(:li, capture(&block), options, true)
    else
      content_tag_string(:li, nil, options, true)
    end
  end
end