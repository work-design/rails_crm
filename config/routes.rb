Rails.application.routes.draw do
  scope RailsCom.default_routes_scope do
    concern :maintainable do
      resources :notes
      resources :orders do
        collection do
          get 'cart/:current_cart_id' => :cart
          post 'cart/:current_cart_id' => :cart_create
          get :unpaid
          post :add
          delete :batch_destroy
          get :new_simple
        end
        member do
          post :package
          post :micro
          get :print_data
          post :print
          match :payment_types, via: [:get, :post]
          post :payment_pending
          post :payment_confirm
          get :print_data
          match :adjust_edit, via: [:get, :post]
          patch :adjust_update
          post :desk_edit
          patch :desk_update
          get :purchase
        end
        resources :order_payments do
          collection do
            post :new_micro
          end
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
          post :confirm
        end
        resources :payment_orders do
          collection do
            post :confirmable
          end
          member do
            post :confirm
            post :cancel
            post :refund
          end
        end
      end
      resources :scan_payments do
        collection do
          post :batch
        end
      end
      resources :hand_payments do
        collection do
          post :batch
        end
      end
      resources :wallet_templates
      resources :wallets, except: [:new] do
        resources :wallet_payments do
          collection do
            post :batch
          end
        end
        resources :wallet_advances
        resources :wallet_logs
      end
      resources :card_templates
      resources :cards do
        resources :card_purchases
      end
      resources :facilitates
      resources :productions do
        member do
          patch :create_dialog
        end
      end
      resources :addresses do
        collection do
          match :order, via: [:get, :post]
          match :order_from, via: [:get, :post]
          post :order_new
          post :order_create
          post :from_new
          post :from_create
          post :search
        end
      end
      resources :provides
    end
    concern :maintaining do
      resources :contacts do
        concerns :maintainable
        collection do
          match :new_detect, via: [:get, :post]
          post :create_detect
        end
        member do
          match :edit_assign, via: [:get, :post]
          patch :update_assign
        end
        resources :maintains, controller: 'contact/maintains' do
          member do
            patch :detach
            match :edit_transfer, via: [:get, :post]
            patch :update_transfer
          end
        end
      end
      resources :clients do
        collection do
          post :search
        end
        resources :productions, controller: 'client/productions' do
          member do
            patch :create_dialog
          end
        end
        resources :orders, controller: 'client/orders' do
          collection do
            post :batch_paid
            delete :batch_destroy
          end
          member do
            match :payment_types, via: [:get, :post]
            post :payment_pending
            post :payment_confirm
            get :print_data
            post :print
          end
        end
        resources :addresses, controller: 'client/addresses'
        resources :notes, controller: 'client/notes'
        resources :maintains, controller: 'client/maintains'
        resources :children, controller: 'client/clients' do
          member do
            match :edit_assign, via: [:get, :post]
            patch :update_assign
            match :edit_organ, via: [:get, :post]
            post :init_organ
          end
        end
        resources :contacts, controller: 'client/contacts' do
          member do
            match :edit_assign, via: [:get, :post]
            patch :update_assign
            match :edit_member, via: [:get, :post]
            post :init_member
            patch :update_default
          end
        end
        concerns :maintainable
        member do
          match :edit_assign, via: [:get, :post]
          patch :update_assign
          match :edit_organ, via: [:get, :post]
          post :init_organ
        end
      end
      resources :maintains do
        concerns :maintainable
        collection do
          get :public
          match :new_batch, via: [:get, :post]
          post :create_batch
          get 'assign' => :new_batch_assign
          post 'assign' => :create_batch_assign
        end
        member do
          match :edit_transfer, via: [:get, :post]
          patch :update_transfer
          match :edit_assign, via: [:get, :post]
          patch :update_assign
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
      resources :wechat_users do
        collection do
          get :online
        end
        member do
          post :contact
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
        namespace :client, default: { namespace: 'client' } do
          resources :clients, only: [] do
            resources :contacts
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
        resources :contacts do
          member do
            get :bind
            delete :destroy_bind
          end
        end
      end

      resources :contacts do
        member do
          get :qrcode
        end
      end
    end
  end

  resolve 'Crm::Source', action: 'source' do |source, options|
    [:crm, :me, source, options]
  end
end
