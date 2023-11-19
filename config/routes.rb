Rails.application.routes.draw do
  scope RailsCom.default_routes_scope do
    concern :maintainable do
      resources :orders do
        collection do
          get 'cart/:current_cart_id' => :cart
          post :add
        end
        member do
          post :package
          post :micro
          get :payment_types
          get :print_data
          get :adjust_edit
          patch :adjust_update
        end
      end
      resources :items do
        collection do
          post :trial
        end
        member do
          patch :toggle
        end
      end
      resources :carts
      resources :payments do
        collection do
          get 'order/:order_id' => :order_new
          post 'order/:order_id' => :order_create
        end
      end
      resources :wallet_templates
      resources :wallets, except: [:new] do
        resources :wallet_payments
        resources :wallet_advances
        resources :wallet_logs
      end
      resources :card_templates
      resources :cards do
        resources :card_purchases
      end
      resources :facilitates
      resources :productions
      resources :addresses do
        collection do
          post :order
          post :order_from
          post :order_new
          post :order_create
          post :from_new
          post :from_create
        end
      end
    end
    concern :maintaining do
      resources :maintains do
        concerns :maintainable
        resources :maintain_logs
        collection do
          get :public
          match :new_batch, via: [:get, :post]
          post :create_batch
          match :new_detect, via: [:get, :post]
          post :create_detect
          get 'assign' => :new_batch_assign
          post 'assign' => :create_batch_assign
        end
        member do
          match :edit_transfer, via: [:get, :post]
          patch :update_transfer
          match :edit_assign, via: [:get, :post]
          patch :update_assign
          match :edit_member, via: [:get, :post]
          post :init_member
          patch :assume
          patch :detach
        end
      end
      namespace :cart do
        resources :maintains, only: [] do
          resources :carts, only: [] do
            resources :addresses
          end
        end
      end
    end
    namespace :crm, defaults: { business: 'crm' } do
      namespace :admin, defaults: { namespace: 'admin' } do
        root 'home#index'
        concerns :maintaining
        resources :clients do
          concerns :maintainable
        end
        resources :client_members do
          concerns :maintainable
        end
        resources :client_organs do
          concerns :maintainable
        end
        resources :maintain_sources do
          collection do
            post :sync
          end
        end
        resources :maintain_tags do
          collection do
            post :sync
          end
        end
        resources :agencies do
          member do
            get 'crowd' => :edit_crowd
            patch 'crowd' => :update_crowd
            delete 'crowd' => :destroy_crowd
            delete 'card' => :destroy_card
          end
        end
      end

      namespace :panel, defaults: { namespace: 'panel' } do
        root 'home#index'
        resources :sources do
          resources :qrcodes
          resources :texts
        end
        resources :tags
      end

      namespace :me, defaults: { namespace: 'me' } do
        concerns :maintaining
        controller :home do
          get :index
        end
        resources :maintains, only: [] do
          collection do
            get 'client/:client_id' => :client
            post 'client/:client_id' => :create_client
          end
        end
        resources :sources do
          collection do
            get :source
            get :list
          end
          member do
            get :source
          end
        end
        resources :agencies
      end

      namespace :my, defaults: { namespace: 'my' } do
        resources :agencies
      end
    end
  end

  resolve 'Crm::Source', action: 'source' do |source, options|
    [:crm, :me, source, options]
  end
end
