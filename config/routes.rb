Rails.application.routes.draw do

  scope module: :crm do

  end

  scope :admin, module: 'crm/admin', as: 'admin' do
    resources :maintain_source_templates
    resources :maintain_tag_templates
    resources :maintains do
      collection do
        get :public
        post :batch
        get 'detect' => :new_detect
        post 'detect' => :create_detect
        get 'assign' => :new_batch_assign
        post 'assign' => :create_batch_assign
      end
      member do
        get :courses
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
      resources :maintain_logs
    end
    resources :maintain_sources do
      post :sync, on: :collection
    end
    resources :maintain_tags do
      post :sync, on: :collection
    end
  end

  scope :my, module: 'crm/my', as: 'my' do
  end

end
