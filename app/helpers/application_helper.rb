module ApplicationHelper
  def nav_item(name, content_or_options_with_block = nil, options = nil, escape = true, &block)

    if options[:rule].nil?
      # set up active
      options[:class] = 'active' if current_page?(options[:link])
    else
      options[:class] = 'active' if options[:link] =~ options[:rule]
    end

    # remove link from hash table
    options[:link] = nil

    if block_given?
      options = content_or_options_with_block if content_or_options_with_block.is_a?(Hash)
      content_tag_string(name, capture(&block), options, escape)
    else
      content_tag_string(name, content_or_options_with_block, options, escape)
    end
  end
end
