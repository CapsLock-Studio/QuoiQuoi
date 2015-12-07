QuoiQuoi::Application.routes.draw do
  devise_for :admin, controller: { sessions: 'admin/sessions' }

  as :admin do
    get 'admin/edit' => 'devise/registrations#edit', as: 'edit_admin_account'
    put 'admin' => 'devise/registrations#update', as: 'admin_account'
  end

  namespace :admin do
    root to: 'home#index'
    resource :privacy_statement, controller: :privacy_statement
    resource :term_of_service, controller: :term_of_service

    resources :home
    resources :articles do
      resources :article_images
    end
    resources :instructions do
      resources :instruction_images
    end
    resources :instruction_images
    resources :article_images
    resources :article_types
    resources :products do
      member do
        put :visible
        patch :visible
      end

      resources :product_custom_items, shallow: true

      # This is one way to shallow nesting resource from http://weblog.jamisbuck.org/2007/2/5/nesting-resources
      # The article is written by Jamis on February 05, 2007 @ 01:00 PM
      # However newest Rails support the "shallow" keyword to make easier
      #resources :product_material_types, name_prefix: 'product_'
      resources :product_material_types, shallow: true do
        member do
          put :visible
          patch :visible

          put :collapsed
          patch :collapsed
        end
      end

      resources :product_addition_images, shallow: true

      resources :product_option_groups, shallow: true do
        resources :product_options, shallow: true
      end
    end

    #resources :product_material_types do
    #  member do
    #    put :visible
    #    patch :visible
    #
    #    put :collapsed
    #    patch :collapsed
    #  end
    #end

    resources :past_work_types do
      member do
        put :visible
        patch :visible
      end

      collection do
        put :sort
        patch :sort
      end

      resources :past_works, shallow: true do
        member do
          put :visible
          patch :visible
        end

        resources :past_work_addition_images, shallow: true
      end
    end

    resources :board
    resources :questions

    resources :product_types

    resources :registrations do
      member do
        get :canceled, action: :show
      end

      collection do
        get :canceled
      end
    end

    resources :registration_payments

    resources :courses do
      member do
        put :status
        patch :status
      end

      resources :registrations, shallow: true
      resources :course_addition_images, shallow: true
      resources :course_option_groups, shallow: true do
        resources :course_options, shallow: true
      end
    end

    resources :travel_information do
      resources :travel_photos
    end
    resources :travel_photos
    resources :areas

    resources :other_products do
      member do
        put :visible
        patch :visible
      end
    end
    resources :designers
    resources :rent_infos
    resources :rent_info_images
    resources :rent_intros
    resources :requirements
    resources :shipping_fees
    resource :about_us, controller: 'about_us'
    resources :introduce_image_slides do
      put 'sort', on: :collection
    end
    resources :introduce_youtubes do
      put 'sort', on: :collection
    end

    resource :requirement_intros

    resources :orders do
      member do
        get :check, action: :check_show
        get :archive, action: :show
        get :canceled, action: :show
      end
      collection do
        get :check
        get :accept
        get :closed
        get :archive
        get :deliver
        get :canceled
      end
    end

    resources :order_payments

    resources :order_remittances do
      member do
        get :check, action: :edit
      end

      collection do
        get :check
      end
    end

    resources :registration_remittances do
      member do
        get :check, action: :edit
      end

      collection do
        get :check
      end
    end

    resources :messages

    resources :custom_orders do
      member do
        get :discussing, action: :show
        get :canceled, action: :show
      end

      collection do
        get :discussing
        get :canceled
      end
    end

    resources :custom_order_options

    resource :remittances

    resources :payments do
      collection do
        get :check
      end

      member do
        put :uncheck
      end
    end

    resources :locales do
      resources :order_information
      resources :instructions
    end
    resources :order_information

    resources :tops do
      put 'sort', on: :collection
    end

    resources :slides do
      put 'sort', on: :collection
    end
    resources :slide_positions
    resources :broadcasts do
      put 'sort', on: :collection
    end

    resources :materials do
      member do
        put :visible
        patch :visible
      end
    end
    resources :material_types do
      member do
        put :visible
        patch :visible

        put :collapsed
        patch :collapsed

        put :all
        patch :all
      end

      resources :materials
    end

    resources :users do
      resources :messages

      member do
        get :info
      end
    end

    resources :gifts do
      member do
        put :visible
        patch :visible
      end
    end
    resources :user_gifts do
      member do
        get :check, action: :check_show
      end

      collection do
        get :check
      end
    end

    resource :system, controller: :system
  end
  ###### namespace admin end ######

  localized do

    # For handling payment
    get 'order_payment/:action(/:id)', controller: :order_payment, as: 'order_payment'
    post 'order_payment_callback/allpay_complete' => 'order_payment_callback#allpay_complete'

    get 'registration_payment/:action(/:id)', controller: :registration_payment, as: 'registration_payment'
    post 'registration_payment_callback/allpay_complete' => 'registration_payment_callback#allpay_complete'

    # Special for paypal payment feedback
    get 'order_payment_callback/paypal' => 'order_payment_callback#paypal'
    get 'orders/:id/cancel?token=EC-\w+' => 'orders#cancel'

    get 'registration_payment_callback/paypal' => 'registration_payment_callback#paypal'
    get 'registrations/:id/cancel?token=EC-\w+' => 'registrations#cancel'

    devise_for :users, controllers: {
        omniauth_callbacks: 'users/omniauth_callbacks'
    }

    get 'search' => 'search#index'

    root to: 'home#index'

    get 'rss' => 'rss#index'
    get 'cart' => 'cart#index'
    put 'cart' => 'cart#update'
    patch 'cart' => 'cart#update'
    get 'cart/checkout' => 'cart#checkout'
    post 'cart/payment' => 'cart#payment'
    get 'user/token/:token' => 'user#email_signin', as: 'email_signin'
    get 'user/email_confirmation' => 'user#email_confirmation'
    post 'user/email_authencate' => 'user#email_authencate', as: 'email_authencate'

    devise_scope :user do
      get 'user' => 'user#index'
      get 'user/edit' => 'user#edit', as: :edit_user
      get 'password' => 'user#password'
      put 'update_password' => 'user#update_password'
      patch 'update_password' => 'user#update_password'
      put 'user' => 'user#update'
      patch 'user' => 'user#update'
      get 'email' => 'user#email'
    end

    resource :home do
      get 'style1' => 'home#style1'
      get 'style2' => 'home#style2'
    end
    resources :products
    resources :news
    resources :courses do
      get 'calendar', on: :collection
      member do
        get 'month(/:month)', action: :show, constraints: {month: /\d{1,2}/}, as: 'month'
        get 'past', action: :show
      end
      collection do
        get 'calendar'
        get 'month(/:month)', action: :index, constraints: {month: /\d{1,2}/}, as: 'month'
        get 'past', action: :past_all
        get 'past(/:id)', action: :past_all, constraints: {id: /\d{4}-\d{1,2}/}, as: 'past'
      end
    end
    resources :reports
    resource :recruitments
    resource :about, controller: 'about'
    resource :rents
    resource :contacts
    resources :messages
    resources :gifts
    resources :user_gifts do
      member do
        get :pay, action: :pay_show
        post :send_email, action: :send_email
      end

      collection do
        post :search
        put :discount
      end
    end

    resources :orders do
      collection do
        get :close, action: :close_index
      end

      member do
        get :close, action: :close_show
        get :pay, action: :pay_show
        put :close
        patch :close
        put :cancel
        post :cancel

        put :report_remittance
        post :report_remittance

        post :return
        put :delivery_report

        post action: :update
      end
    end

    resources :order_products
    resources :registrations do
      collection do
        get :close, action: :close_index
        post :payment
      end

      member do
        get :close, action: :close_show
        get :pay, action: :pay_show

        put :cancel
        post :cancel

        put :report_remittance
        post :report_remittance

        post :return

        post action: :update
      end
    end

    resources :past_work_types do
      resources :past_works
    end

    resources :product_types do
      resources :products
    end

    resources :payments do
      collection do
        get :success
        get :cancel
        post :notify
        get :show
      end
    end

    resources :articles
    resources :areas do
      resources :travel_information
    end

    resources :custom_orders do
      member do
        put :cancel
        patch :cancel
      end
      collection do
        get :build
      end
    end

    resources :order_custom_items
    resources :material_types
    resources :materials do
      collection do
        get 'like'
      end
    end

    resource :terms_of_service, controller: :terms_of_service
    resource :privacy_statement, controller: :privacy_statement
    
  end
end