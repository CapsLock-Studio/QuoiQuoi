Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '272021534067-lok2hi9b89tt64v1deeks9ngirbpnhq3.apps.googleusercontent.com', '8WJUxxHQI8Pa6hitnI8F4WRk'
  provider :facebook, '767771689901246', 'c59791c087a2ae89280c1cab7d2242bb'

end