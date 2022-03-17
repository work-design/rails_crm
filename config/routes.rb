Rails.application.routes.draw do

  namespace :crm, defaults: { business: 'crm' } do
    namespace :admin, defaults: { namespace: 'admin' } do
      resources :maintains do
        resources :maintain_logs
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
          get :orders
          get 'order' => :edit_order
          patch 'order' => :update_order
        end
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
    end

    namespace :panel, defaults: { namespace: 'panel' } do
      resources :sources do
        resources :materials
      end
      resources :tags
    end

    namespace :me, defaults: { namespace: 'me' } do
      controller :home do
        get :index
      end
      resources :maintain_sources do
        collection do
          get :source
        end
      end
    end
  end

end
