EpochNewspaperBoxes::Application.routes.draw do
  root "newspaper_boxes#map"
  devise_for :users

  get 'newspaper_bases/map', to: 'newspaper_bases#map'
  resources :newspaper_base, :newspaper_boxes, :newspaper_hands do
    collection do
      get 'map'
      get 'export_data'
    end
    member do
      get 'recovery'
    end
  end

  resources :histories do
    get :trend, on: :collection
  end

  resources :reports do
    collection do
      get 'report'
      get 'zipcode_report'
    end
  end
end
