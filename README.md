QuoiQuoi ![build-status](https://travis-ci.org/CapsLock-Studio/QuoiQuoi.svg?branch=master) [![Dependency Status](https://www.versioneye.com/user/projects/58fdccbac2ef4238147e69ec/badge.svg?style=flat-square)](https://www.versioneye.com/user/projects/58fdccbac2ef4238147e69ec)
========

Rails Website for QuoiQuoi studio

## About
You can use this project to the case study for Rails in real business website.

## Environment
- ![ruby-version](https://img.shields.io/badge/ruby-2.4.0-red.svg)
- Redis
- PostgreSQL
 
## Which techs used in this project.
#### ActiveJobs


## Configurations
### Use a strong token to protect your cookie
Run `rake secret` to obtain a strong secret token and put it into `config/initializers/secret_token.rb`.
```ruby
QuoiQuoi::Application.config.secret_key_base = 'TOKEN FROM [rake secret]'
```

### Set up devise
Run `devise:install` command in your project. [Devise getting started](https://github.com/plataformatec/devise#getting-started)
 
### Add secrets for omni-auth
QuoiQuoi support user sign in with Google or Facebook by omni-auth. You have to apply your test app at [Google API Console](https://console.developers.google.com) and [Facebook for Developers](https://developers.facebook.com).

After registering your app and putting these keys and secrets into `config/initiailizers/omniauth.rb`. There is a little different to [OmniAuth getting started](https://github.com/omniauth/omniauth#getting-started) document. We supply omni-auth hull host variable for sign in from email token. 
```ruby
OmniAuth.config.full_host = Rails.env.production? ? 'https://YOUR_PRODUCTION_DOMAIN' : 'http://localhost:3000'
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, 'OAUTH_TOKEN'
  provider :facebook, 'APP_ID', 'APP_SECRET'
end

```

### Set up reCAPTCHA v2
QuoiQuoi allows users to register courses without sign in, reCAPTCHA protect our service from BOT attack, it really good. You have to [Get reCAPTCHA](https://www.google.com/recaptcha/admin#list) and add key and secret to `config/initializers/recaptcha.rb` ([Alternative API key setup](https://github.com/ambethia/recaptcha#alternative-api-key-setup)).
```ruby
Recaptcha.configure do |config|
  config.site_key  = 'YOUR_RECAPTCHA_SITE_KEY'
  config.secret_key = 'YOUR_RECAPTCHA_SECRET_KEY'
end
```
Unfortunately we has not upgrade to invisible reCAPTCHA, it is a TO-DO item.

### Paypal
Register a REST app in paypal developer.
```yaml
development: &sandbox # change to your own
  username: SET_YOUR_OWN
  password: SET_YOUR_OWN
  signature: SET_YOUR_OWN
  sandbox: true

test:
  <<: *sandbox

production: &production
  username: SET_YOUR_OWN
  password: SET_YOUR_OWN
  signature: SET_YOUR_OWN
  sandbox: false
```

### ECPay
ECPay is a payment solution and pretty easy to integrate in Taiwan. 

You have to register the developer account in [ECPay](https://www.ecpay.com.tw), then put your merchant id, hash key, and iv to `config/initializers/allpay.rb`.
```ruby
require 'allpay'

AllPay.setup do |allpay|
  if Rails.env.production?
    allpay.merchant_id = 'write your production merchant_id'
    allpay.hash_key    = 'write your production hash_key'
    allpay.hash_iv     = 'write your production hash_iv'
  else
    allpay.merchant_id = 'write your development merchant_id'
    allpay.hash_key    = 'write your development hash key'
    allpay.hash_iv     = 'write your development hash iv'
  end
end
```

ECPay will send the payment result at path `http://domain.com/order_payment_callback/allpay_complete`, `http://domain.com/registration_payment_callback/allpay_complete` by `POST` method. So if you want to try payment in localhost it will be impossible.
