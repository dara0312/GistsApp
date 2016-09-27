Rails.application.routes.draw do
  root 'welcome#index'

  get '/collect'              => 'welcome#collect'
  get '/collect/:id'          => 'welcome#collect', :contraints => { :id => /\d*/ }, as: 'collectpage'

  get '/categories'           => 'welcome#categories_home', as: 'categorieshome'
  get '/categories/:name'     => 'welcome#categories', :contraints => { :name => /\s*/ }, as: 'categoriesname'
  get '/categories/:name/:id' => 'welcome#categories', :contraints => { :name => /\s*/, :id => /\d*/ }

  get '/search'               => 'welcome#search', as: 'search'
  post '/search'              => 'welcome#searchpost', as: 'searchvalid'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
