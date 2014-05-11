QuoiQuoi::Application.routes.draw do
  get "other_products/Admin"
  devise_for :admin, controller: { sessions: 'admin/sessions' }

  # Disable new registration but allow edit
  as :admin do
    get 'admin/edit' => 'devise/registrations#edit', as: 'edit_admin_registration'
    put 'admin' => 'devise/registrations#update', as: 'admin_registration'
  end

  devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}

  namespace :admin do
    root to: 'home#index'
    resources :home
    resources :articles
    resources :article_types
    resources :products
    resources :product_types
    resources :courses
    resources :course_types
    resources :other_products
    resources :designers
    resources :rent_infos
    resources :rent_info_images
    resources :rent_intros
    resources :requirements
    resource :contacts
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

  get 'user' => 'user#index'
  get 'user/edit' => 'user#edit', as: :edit_user
  get 'password' => 'user#password'
  put 'user' => 'user#update'
  patch 'user' => 'user#update'

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

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
