Myav::Application.routes.draw do
  root "main#index"
  namespace :api, :defaults => { :format => 'json' } do
    resources :users, :constraints => {:id => /[^\/]+/} do
      collection do
      end
    end
  end
  get "*path" => "main#index"
end
