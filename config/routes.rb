EpochNewspaperBoxes::Application.routes.draw do
	root "newspaper_boxes#map"
  devise_for :users

  resources :newspaper_boxes, except: [:show, :edit] do
    collection do
      get 'map'
      get 'export_data'
    end
    member do
      get 'recovery'
    end
  end

  resources :newspaper_hands, except: [:show, :edit] do
    collection do
      get 'map'
      get 'export_data'
    end
    member do
      get 'recovery'
    end
  end

  resources :histories
  resources :reports do
    collection do
      get 'report'
      get 'zipcode_report'
    end
  end
end
