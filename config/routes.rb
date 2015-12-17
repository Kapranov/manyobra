Rails.application.routes.draw do

  

  #mount Markitup::Rails::Engine, at: "markitup", as: "markitup"
  #resources :services

  #ActionDispatch::Routing::Translator.translate_from_file('config/locales/routes.yml')
  #resources :posts, only: [:index]
  #scope "blog" do
  #blog app
  namespace :blog do
    resources :posts do
      resources :comments, :only => [:create]
    end
    match 'search', to: 'search#search', as: :search, via: [:get]
    resources :categories
    resources :tags
  end
  
  root :to => "pages#index"

  
  match 'account/signup', to: 'users#new', as: :signup, via: 'get'
  match 'account/login', to: 'sessions#new', as: :login, via: 'get'

  get 'account/logout', to: 'sessions#destroy', as: 'logout'
  match 'account/dashboard', to: 'users#dashboard', as: :dashboard, via: 'get'
  match 'profile/password', to: 'passwords#new', as: :change_password, via: 'get'
  match 'profile/change_time_zone', to: 'users#change_time_zone', as: :change_time_zone, via: [:get, :post]
  #get 'profile/language', to: 'users#change_language', as: 'change_language'
  match 'profile/currency', to: "users#change_currency", as: :change_currency, via: [:get, :post]
  match 'profile/language', to: "users#change_language", as: :change_language, via: [:get, :post]
  match 'profile/avatar', :to => "users#avatar", as: :avatar, via: [:get, :post]
  match 'account/profile', to: 'users#profile', as: :profile, via: [:get, :post]


  #get 'contact' => 'contact#new'
  #get 'contact_send' => 'contact#create'
 
  get "/admin" => "admin/base#index", :as => "admin"

  get "sitemap.xml" => "pages#sitemapxml", format: :xml, as: :sitemapxml
  get "robots.txt" => "pages#robots", format: :text, as: :robots

  namespace :admin do
    resources :services
    resources :users
  end
  
  scope "(:locale)", :locale => /en|es|ru/ do
    #root :to => 'page#index'
    #get "page/index"
  #end
  match 'conversations', to: 'conversations#index', as: :conversations, via: 'get'
  get '/', to: 'pages#home', as: :page_home
  #get '/home', to: 'pages#home', as: :page_home
  get '/services/', to: 'pages#services', as: :page_services
  match '/prices/', to: 'pages#prices', as: :page_prices, via: [:get, :post]
  get '/about/', to: 'pages#about', as: :page_about_us
  get '/customers/', to: 'pages#customers', as: :page_customers
  get '/testimonials/', to: 'pages#testimonials', as: :page_testimonials
  get '/features/', to: 'pages#features', as: :page_features
  # for scope
  #get '/blog', to: 'posts#index', as: :blog
  #for namespace
  get '/blog/', to: 'blog/posts#index', as: :blog
  get '/events/', to: 'pages#events', as: :page_events
  get "/sitemap/", to: "pages#sitemap", as: :page_sitemap
  get '/offers/', to: 'pages#offers', as: :page_offers
  #get '/not_found', to: 'pages#not_found', as: :page_not_found
  match 'pages/order_call', to: 'pages#order_call', as: 'order_call', via: 'get'
  match '/contact/', to: 'pages#contact', as: :page_contact, via: [:get, :post]
  resources :contacts
  #get '/contact', to: 'contacts#new', as: 'page_contact'
  
  scope path: "/services" do
    get '/extensive-repairs/', to: 'pages#extensive_repairs', as: :service_page_extensive_repairs
    get '/repair-of-kitchen/', to: 'pages#repair_of_kitchen', as: :service_page_repair_of_kitchen
    get '/installation-of-an-electrical-wiring/', to: 'pages#installation_of_an_electrical_wiring', as: :service_page_installation_of_an_electrical_wiring
    get '/repair-of-bathrooms', to: 'pages#repair_of_bathrooms', as: :service_page_repair_of_bathrooms
    get '/installation-of-plumbing', to: 'pages#installation_of_plumbing', as: :service_page_installation_of_plumbing
    get '/repair-of-office-and-industrial-premises', to: 'pages#repair_of_office_and_industrial_premises', as: :service_page_repair_of_office_and_industrial_premises
    get '/registration-of-licenses', to: 'pages#registration_of_licenses', as: :service_page_registration_of_licenses
    get '/drafting-projects-of-architectural-and-engineering', to: 'pages#drafting_projects_of_architectural_and_engineering', as: :service_page_drafting_projects_of_architectural_and_engineering
    get '/construction', to: 'pages#construction', as: :service_page_construction
    get '/reforms-in-neighboring-communities', to: 'pages#reforms_in_neighboring_communities', as: :service_page_reforms_in_neighboring_communities
    get '/urgent-repair', to: 'pages#urgent_repair', as: :service_page_urgent_repair
    get '/debt-collection', to: 'pages#debt_collection', as: :service_page_debt_collection
    get '/legal-service', to: 'pages#legal_service', as: :service_page_legal_service
    get '/labor', to: 'pages#labor', as: :service_page_labor
    get '/civil', to: 'pages#civil', as: :service_page_civil
    get '/family', to: 'pages#family', as: :service_page_family
  end
  end
  resources :users
  resources :sessions
  resources :passwords
  resources :password_resets
  #resources :contact



  # temporarily
  match "*path", to: "pages#not_found", as: :page404, via: [:get, :post] # handles /en/fake/path/whatever
end




=begin
Rails.application.routes.draw do
  resources :contacts

  namespace :admin do
    resources :services
  end

  resources :services

  resources :comments

  resources :posts

  get 'password_resets/new'

  scope path: "/account" do
  get 'login', to: 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout
  get 'signup', to: 'users#new', as: :signup
  get 'user/dashboard', to: 'users#dashboard', as: :dashboard
  #match '/:username/dashboard', :to => "users#dashboard", :as => :dashboard, via: [:get, :post]
  #get 'profile', to: 'users#profile', as: 'profile'
  match 'users/profile', to: 'users#profile', as: :profile, via: [:get, :post]
  #get 'profile', to: 'users#profile_update', as: 'profile_update'


  get 'change_password', to: 'passwords#new', as: :change_password
  match 'change_time_zone', to: 'users#change_time_zone', as: :change_time_zone, via: [:get, :post]
  #get 'profile/language', to: 'users#change_language', as: 'change_language'
  match 'profile/currency', to: "users#change_currency", as: :change_currency, via: [:get, :post]
  match 'profile/language', to: "users#change_language", as: :change_language, via: [:get, :post]
  match 'profile/avatar', :to => "users#avatar", as: :avatar, via: [:get, :post]



    resources :users
    resources :sessions, only: [:new, :create, :destroy]
    resources :passwords
  end

  #resources :announcements

  #match '/home' => 'pages#home', via: [:get]
  #match '/about' => 'pages#about', via: [:get]
  #match '/contact' => 'pages#contact', via: [:get, :post]


  #match 'announcement/new', to: 'announcement/announcements#new', as: :new_announcement, via: [:get, :post]
  #match 'announcement/edit', to: 'announcements#edit', as: :edit_announcement, via: [:get, :post]
  
  #match 'announcements/:id/hide', to: 'announcements#hide', as: 'hide_announcement', via: [:get, :post]
  #match 'announcements/:id/hide', to: 'announcements#hide', as: 'hide_announcement'
  
  #root to: 'pages#home'
  
  #for website app
  scope ":locale", locale: /#{I18n.available_locales.join("|")}/ do

    #resources :pages
    get '/home', to: 'pages#home', as: :home
    get '/about', to: 'pages#about', as: :about_me
    match '/contact', to: 'pages#contact', as: :contact, via: [:get, :post]
    match "/" => "pages#home", via: [:get, :post]
    #root 'pages#home'
    match "*path", to: "pages#404", via: [:get, :post] # handles /en/fake/path/whatever
  end
  get "/*path", to: redirect("/#{I18n.locale}/%{path}", status: 302), constraints: {path: /(?!(#{I18n.available_locales.join("|")})\/).*/}, format: false
  #match '*path', to: redirect("/#{I18n.locale}/%{path}"), constraints: lambda { |req| !req.path.starts_with? "/#{I18n.default_locale}/" }, via: [:get, :post]
  root to: redirect("/#{I18n.locale}/home"), via: [:get]
 
  # handles /bad-locale|anything/valid-path
  match '/*locale/*path', to: redirect("/#{I18n.locale}/%{path}"), via: 'get'
  #match ':controller/:action.:format'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
=end