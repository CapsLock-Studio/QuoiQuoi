module ApplicationHelper
  def nav_item(link, options = nil, &block)
    options ||= {}
    options[:class] ||= ''

    if options[:rule].nil?
      # set up active
      options[:class] << ' active' if current_page?(link)
    else
      options[:class] << ' active' if request.env['PATH_INFO'] =~ options[:rule] || request.env['REQUEST_URI'] =~ options[:rule]
      options[:rule] = nil
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
        options[:class] << ' active' if request.env['PATH_INFO'] =~ options[:rule] || request.env['REQUEST_URI'] =~ options[:rule]
        options[:rule] = nil
      end

      if block_given?
        content_tag_string(:li, capture(&block), options, true)
      else
        content_tag_string(:li, nil, options, true)
      end
    end
  end

  def is_in(name = nil)
    if name
      controller_name.to_sym == name
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

  def link_to_with_product_type(product, &block)
    link_path = product_path(product)
    unless product.product_type.nil?
      link_path = product_type_product_path(product.product_type, product)
    end

    if block_given?
      link_to(capture(&block), link_path)
    else
      link_to link_path
    end
  end

  def locale_discount(discount, locale = nil)
    if (locale.nil?)? session[:locale] == 'en' : locale == 'en'
      discount = (10 - discount) * 10
    end

    discount.to_i
  end

  def price_discount(price, discount)
    if discount > 0
      price = price * discount / 10
    end

    price
  end

  def custom_item_name_helper(custom_item, locale_id = nil)
    name = t('original_bag')
    if custom_item.product
      product = ProductTranslate.where(product_id: custom_item.product_id)
      if locale_id.nil?
        product = product.where(locale_id: session[:locale_id]).first
      else
        product = product.where(locale_id: locale_id).first
      end
      name = "#{product.name}(#{t('mended')})"
    end

    name
  end

  def custom_item_image_helper(custom_item, style = :thumb, option = '')
    image_url = custom_item.image.url(style)
    if !custom_item.image.exists? && custom_item.product
      image_url = custom_item.product.image.url(style)
    end

    image_tag "#{root_url}#{image_url}", class: option
  end
end