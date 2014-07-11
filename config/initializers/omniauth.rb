Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '363464624007-tvlbrfgmlq5bcj16ghvfu31tqst6v4lh.apps.googleusercontent.com', '0RJIo-QMyLEQ4FosYBflKk57'
  provider :facebook, '767771689901246', 'c59791c087a2ae89280c1cab7d2242bb'
  provider :twitter, 'RAcgcBo1BxGiBbHbLr5C1WRZl', 'FRkjJJ1j3BPzFHnQGbwwbVLpESSa80lGpgp2VSpWvh9AUztHv0'
end