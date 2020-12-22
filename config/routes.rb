Rails.application.routes.draw do

  scope module: :crm, defaults: { business: 'crm' } do

  end

  scope :admin, module: 'crm/admin', as: :admin, defaults: { namespace: 'admin', business: 'crm' } do
    resources :maintain_source_templates
    resources :maintain_tag_templates
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
      post :sync, on: :collection
    end
    resources :maintain_tags do
      post :sync, on: :collection
    end
  end

  scope :my, module: 'crm/my', as: :my, defaults: { namespace: 'my', business: 'crm' } do
  end

end
