Rails.application.routes.draw do
  scope RailsCom.default_routes_scope do
    concern :maintaining do
      resources :maintains do
        resources :maintain_logs
        resources :orders do
          collection do
            post :add
          end
          member do
            post :package
            get :payment_types
            get :print_data
          end
        end
        resources :payments do
          collection do
            get :order_new
            post :order_create
          end
        end
        resources :wallet_templates
        resources :wallets, only: [:index] do
          resources :wallet_payments
          resources :wallet_logs
        end
        resources :card_templates
        resources :cards do
          resources :card_purchases
        end
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
        collection do
          get :public
          post :batch
          get 'detect' => :new_detect
          post 'detect' => :create_detect
          get 'assign' => :new_batch_assign
          post 'assign' => :create_batch_assign
        end
        member do
          get 'transfer' => :edit_transfer
          patch 'transfer' => :update_transfer
          get 'assign' => :edit_assign
          patch 'assign' => :update_assign
          patch :assume
          patch :detach
        end
      end
    end
    namespace :crm, defaults: { business: 'crm' } do
      namespace :admin, defaults: { namespace: 'admin' } do
        root 'home#index'
        concerns :maintaining
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
        resources :maintain_sources do
          collection do
            get :source
            get :list
          end
        end
        resources :agencies
      end

      namespace :my, defaults: { namespace: 'my' } do
        resources :agencies
      end
    end
  end

  resolve 'Crm::Source', controller: 'maintain_sources', action: 'source' do |source, options|
    [:crm, :me, options]
  end
end
