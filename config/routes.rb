QuoiQuoi::Application.routes.draw do
  get "other_products/Admin"
  devise_for :admin, controller: { sessions: 'admin/sessions' }

  as :admin do
    get 'admin/edit' => 'devise/registrations#edit', as: 'edit_admin_registration'
    put 'admin' => 'devise/registrations#update', as: 'admin_registration'
  end

  devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}

  namespace :admin do
    root to: 'home#index'
    resources :home
    resources :articles do
      resources :article_images
    end
    resources :article_images
    resources :article_types
    resources :products
    resources :product_types
    resources :courses
    resources :course_registrations do
      member do
        put :cancel, action: :cancel_one
        patch :cancel, action: :cancel_one
        put :return
        patch :return

        get :canceled, action: :canceled_show
        put :canceled, action: :canceled_return
        patch :canceled, action: :canceled_return

        get :closed, action: :closed_show
      end

      collection do
        get :canceled
        get :closed
      end
    end

    resources :travel_information do
      resources :travel_photos
    end
    resources :travel_photos
    resources :areas

    resources :other_products
    resources :designers
    resources :rent_infos
    resources :rent_info_images
    resources :rent_intros
    resources :requirements
    resources :shipping_fees
    resource :contacts
    resources :contact_image_slides do
      put 'sort', on: :collection
    end
    resources :contact_youtube_slides do
      put 'sort', on: :collection
    end

    resource :requirement_intros

    resources :registrations do
      member do
        get :check, action: :check_show
      end

      collection do
        get :check
      end
    end

    resources :orders do
      member do
        get :check, action: :check_show
      end
      collection do
        get :check
        get :accept
        get :closed
        get :deliver
        get :canceled
      end
    end

    resources :messages

    resources :order_custom_items do
      collection do
        get :accepted
        get :canceled
        get :check
      end
    end

    resource :remittances

    resources :payments do
      collection do
        get :check
      end

      member do
        put :uncheck
      end
    end

    resources :locales
    resources :slides do
      put 'sort', on: :collection
    end
    resources :slide_positions
    resources :broadcasts do
      put 'sort', on: :collection
    end
    resources :materials

    resources :users do
      resources :messages
    end

    resources :gifts
    resources :user_gifts do
      member do
        get :check, action: :check_show
      end

      collection do
        get :check
      end
    end
  end

  root to: 'home#index'
  get 'cart' => 'cart#index'

  devise_scope :user do
    get 'user' => 'user#index'
    get 'user/edit' => 'user#edit', as: :edit_user
    get 'password' => 'user#password'
    put 'update_password' => 'user#update_password'
    patch 'update_password' => 'user#update_password'
    put 'user' => 'user#update'
    patch 'user' => 'user#update'
  end

  resource :home do
    get 'style1' => 'home#style1'
    get 'style2' => 'home#style2'
  end
  resources :products do
    collection do
      get 'search'
    end

    resource :order_custom_items
  end
  resources :news
  resources :courses do
    get 'calendar', on: :collection
  end
  resources :reports
  resource :requirements
  resource :contacts
  resource :rents

  resources :messages
  resources :gifts
  resources :user_gifts do
    member do
      get :pay, action: :pay_show

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
    end
  end

  resources :order_custom_items do
    collection do
      get :material
    end

    member do
      put :cancel
    end
  end
  resources :order_products
  resources :registrations do
    collection do
      get :close, action: :close_index
    end

    member do
      get :close, action: :close_show
      get :pay, action: :pay_show
    end
  end

  resources :product_types do
    resources :products
  end

  resources :payments do
    collection do
      get :success
      get :cancel
      post :notify
    end
  end

  resources :articles
end
