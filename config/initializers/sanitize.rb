class Sanitize
  module Config
    ALLOWED = freeze_config(
        elements: RESTRICTED[:elements] + %w[a img br b i u h1 h2 h3 h4 h5 h6 ul ol li blockquote],
        attributes: {
            'a' => %w[href target title],
            'img' => %w[src class]
        },

        :add_attributes => {
            'a' => { 'rel' => 'nofollow'}
        },

        protocols: {
            'a' => {
                href: ['ftp', 'http', 'https', 'mailto', :relative]
            },
            'img' => {
                src: ['http', 'https', :relative]
            }
        }
    )
  end
end