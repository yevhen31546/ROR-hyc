#Codereview
NewSite::Application.routes.draw do
  get "tides/index"

  #match '/forum' => redirect('/forum/forums/1')
  # mount Forem::Engine, :at => "/forum"
  resources :bs_ads, :path => 'buy-and-sell'
  resources :crew_finder_ads, :path => 'crew-finder'

  resources :contacts
  resources :committees

  root :to => 'welcome#index'

  match 'webcam' => 'welcome#webcam'

  resource :account, :controller => 'account'
  #post '/signup' => 'account#create', :as => :signup
  #get '/signup' => 'account#new', :as => :signup
  #match '/account/edit' => 'account#edit', :as => :edit_account

  get "payment_confirmation" => 'entry_payment_confirmation#index'

  get "/pay-now" => 'pay_now#index'
  post "/pay-now" => 'pay_now#create', :as => :create_order
  match "/pay-now/pay" => 'pay_now#pay'
  match "/pay-now/complete_3d_secure" => "pay_now#complete_3d_secure", :as => :complete_3d_secure_order
  match "/pay-now/enter_3d_secure" => "pay_now#enter_3d_secure"
  match "/pay-now/thank-you" => "pay_now#thank_you"

  resources :password_resets
  post '/login' => 'user_sessions#create', :as => :login
  get '/login' => 'user_sessions#new', :as => :login
  get '/login', :to => "user_sessions#new", :as => :sign_in # forem gem needs this to work
  match '/logout' => 'user_sessions#destroy', :as => :logout
  match '/forgot-password' => 'password_resets#new', :as => :forgot_password
  match '/reset-password/:id' => 'password_resets#edit', :as => :reset_password

  match '/sitemap' => 'misc#sitemap'
  match '/subscribe' => 'subscriptions#new', :as => :subscribe
  match '/contact' => 'contact_us#index', :as => :contact_us
  match '/enquire' => 'enquiry#index', :as => :enquiry

  resources :testimonials
  resources :team_members, :path => 'team'
  resources :subscriptions

  match 'junior', :controller => 'news_items', :action => :index, :only_junior => true, :as => :junior
  match 'cruising-news', :controller => 'news_items', :action => :index, :only_cruising => true, :as => :cruising
  match 'social', :controller => 'news_items', :action => :index, :only_social => true, :as => :social
  resources :news_items, :path => 'news' do
    collection do
      get 'page/:page', :action => :index
      get 'categories/:news_category_id', :action => :index, :as => :category
    end
  end

  match '/open-events', :controller => 'events', :action => :index, :event_type => 'open', :as => :open_events
  match '/club-events', :controller => 'events', :action => :index, :event_type => 'club'
  #delegator add training events Sep 2019
  match '/training-events', :controller => 'events', :action => :index, :event_type => 'training'
  match '/admin/events/train', :controller => 'admin/events', :action => 'train', :event_type => 'training'

  resources :social_events, :only => [:index, :show]

  resources :events do
    collection do
      get :calendar_ajax
      get :options
      get :three_d_secure_payment_test
    end

    resources :entries do
      member do
        match :payment
        match :complete_3d_secure
        match :enter_3d_secure
        match :thank_you
      end

    end

    resources :event_dinner_bookings, :path => "dinner-booking", :only => [:index, :new, :create] do
      member do
        match :payment
        match :complete_3d_secure
        match :enter_3d_secure
      end

      collection do
        get :list
        get :thank_you
        post :total_charge
        put :total_charge
      end
    end
  end

  match '/results' => 'results#index'
  match '/results/class_options' => 'results#class_options'
  match '/results/event_options' => 'results#event_options'
  match '/results/:id/iframe' => 'results#iframe', :as => :iframe_result
  get '/results/getold' =>'results#getold', :as=> :get_old
  resources :entries do
    collection do
      match :charge_total
    end
  end

  resources :blog_comments, :path => 'blog/comments'
  resources :blog_categories, :path => 'blog/categories'
  resources :blog_posts, :path => 'blog' do
    get 'page/:page', :action => :index, :on => :collection
  end

  resources :videos

  get '/gallery/:gallery_category_id' => 'gallery_categories#show', :as => :gallery_category, :constraints => { :gallery_category_id => /\d+[^\/]+/ }
  get '/gallery/albums/:gallery_album_id' => 'gallery_photos#index', :as => :gallery_album_gallery_photos, :constraints => { :gallery_album_id => /\d+[^\/]+/ }
  resources :gallery_photos, :path => 'photos' do
    collection do
      get :search
    end
  end

  post '/admin/gallery/albums/update_all' => 'admin/gallery_albums#update_all', :as => :update_all_admin_gallery_albums
  
  resources :gallery_categories, :path => 'gallery' do
    resources :gallery_albums, :path => 'albums' do
      resources :gallery_photos, :path => 'photos'
    end
  end

  resources :trophy_winners do
    collection do
      get :rankings
      get :options
    end
  end

  resources :crane_hire_bookings, :path => "crane-booking", :only => [:index, :new, :create] do
    member do
      match :payment
      match :complete_3d_secure
      match :enter_3d_secure
    end

    collection do
      get :thank_you
      get :time_slots
      post :total_charge
      put :total_charge
    end
  end

  match 'admin' => 'admin/dashboard#index', :as => :admin
  match 'admin/dashboard/announcements_ajax' => 'admin/dashboard#announcements_ajax', :as => :announcements_ajax
  match 'admin/modules' => 'admin/admin_modules#index', :as => :admin_modules
  namespace :admin do
    match 'online_entry' => 'online_entry#index' # this is just a holder for links to other online entry related modules

    resources :bs_ads do
      member do
        match :approve
        match :reject
        match :activate
        match :deactivate
      end
    end
    resources :crew_finder_ads do
      collection do
        get :export
      end
      member do
        match :approve
        match :reject
      end
    end
    resources :committees
    resources :pages
    resources :contacts do
      collection do
        match :update_positions
      end
    end
    resources :resources
    resources :testimonials
    resources :clubs
      #delegator add training events Sep 2019
    resources :trains
    resources :trophy_winners do
      collection do
        post :update_all
        match :duplicate
      end
    end
    resources :team_members, :path => 'team'
    resources :images
    resources :enquiries do
      collection do
        match :export
      end
    end
    resources :news_categories, :path => 'news/categories'
    resources :news_items, :path => 'news'
    resources :event_resources do
      collection do
        match :update_positions
      end
    end
    resources :social_events
    resources :events do
      resources :event_resources
      collection do
        match :new_date
        match :new_event_logo
        get :options
        get :club
          #delegator add training events Sep 2019
        get :train
        get :open
      end
    end

    resources :event_dinners do
      collection do
        get :options
      end
    end

    resources :event_dinner_bookings do
    end

    resources :entry_forms do
      member do
        match :duplicate
      end
      collection do
        match :update_charge_positions
        match :update_category_positions
        match :new_charge
        match :new_category
      end
    end
    resources :entries do
      collection do
        match :new_crew_member
        match :multiple
      end
    end

    resources :entry_lists do
      collection do
        get :options_for_event
      end
    end

    resources :rigs
    resources :boat_categories
    resources :boat_classes

    resources :users
    resources :assets do
      member do
        match :thumbnail
      end
    end

    resources :tides do
      collection do
        match :add_multiple
        match :delete_multiple
        match :delete_by_year
      end
    end

    resources :navbar_items
    resources :navbars do
      post :update_position, :on => :member
      get :navbar, :on => :member
      resources :navbar_items
    end

    resources :blog_comments, :path => 'blog/comments' do
      get :approve, :on => :member
    end
    resources :blog_categories, :path => 'blog/categories'
    resources :blog_posts, :path => 'blog'

    resources :videos
    resources :gallery_photos, :path => 'photos'
    resources :gallery_albums, :path => 'gallery' do
      resources :gallery_photos, :path => 'photos' do
        get :use_as_cover, :on => :member
        match :upload, :on => :collection
        match :multiple, :on => :collection
      end
    end
    resources :gallery_categories


    resources :admin_modules do
      post :update_multiple, :on => :collection
    end
    resources :subscriptions do
      get :copy_paste, :on => :collection
    end
    resources :settings do
      collection do
        post :update_all
      end
    end

    resources :results do
      collection do
        get :open
        get :club
          #delegator add training events Sep 2019
        get :train
        post :update_all
      end
      member do
        match :delete_by_event_title
      end
    end
    resources :fleets
    resources :boat_builders
    resources :countries
    resources :trophy_events do
      collection do
        post :update_all
        match :duplicate
        match :options
      end
    end

    resources :products
    resources :product_categories
    resources :orders do
      collection do
        get :export
      end
    end

    resources :crane_hire_bookings do
      collection do
        get :payment_list
        get :full_list
        get :print
      end
    end

    resources :crane_hire_prices
  end

  Dir.glob(Rails.root.join('app/views/misc/[^_]*')).collect do |filename|
    p = File.basename(filename).gsub(/\.+.*/, '')
    match "/#{p.gsub(/_+/, '-')}", :controller => 'misc', :action => p
  end

  match '/robots.txt' => 'welcome#robots', :format => :txt


  match '/resultsselector' => redirect("/results")
  match '/corporate*any'   => redirect("/events-and-conferences")
  match '/buyandsell*any' => redirect("/buy-and-sell")
  match '/openevents13' => redirect("/open-events")
  match '/familycruisingweek*any' => redirect("/about-our-club")
  match '/J24Europeans2011' => redirect("/")
  match '/J24worldChampionship2013*any' => redirect("/")
  match '/howtharea*any' => redirect('/howth-area')
  match '/socialActivities' => redirect('/social_events')
  match '/clubhouse*any' => redirect('/club-house')
  match '/trophywin*any' => redirect('/trophy_winners')
  match '/terms.asp' => redirect('/')
  match '/privacy.asp' => redirect('/')
  match '/openevents*any' => redirect('/open-events')
  match '/clubracing*any' => redirect('/club-racing')
  match '/dinghies*any' => redirect('/junior-sailing')
  match '/howthSeventeen*any' => redirect('/howth-17')
  match '/howthseventeen*any' => redirect('/howth-17')
  match '/catering*any' => redirect('/hospitality')
  match '/gallery2*any' => redirect('/gallery')
  match '/ribsAndRescue*any' => redirect('/about-our-club')
  match '/contacts*any' => redirect('/contact')
  match '/membershipInfo*any' => redirect('/join-our-club')
  match '/clubinsignia*any' => redirect('/club-insignia')
  match '/crewfinder*any' => redirect('/crew-finder')
  match '/sportsboatCup*any' => redirect('/crew-finder')
  match '/RibsAndRescue*any' => redirect('/about-our-club')
  match '/tides/*any' => redirect('/')
  match '/marina/localFacilities.asp' => redirect('/marina-services-facilities')
  match '/marina/marineCharges.asp' => redirect('/marina/rates')
  match '/marina*any.asp' => redirect('/marina')
  match '/results/*any.asp' => redirect('/results')
  match '/members/logon.asp' => redirect('/account')
  match '/news/newsview' => redirect('/news')
  match '/news/*any.asp' => redirect('/news')
  match '/websiteinfo*any' => redirect('/contact')
  match '/calsailing*any' => redirect('/open-events')
  match '/home*any' => redirect('/')
  match '/hospitality/hospitalityHome.asp' => redirect('/hospitality')
  match '/social/*any' => redirect('/social_events')
  match '/raceArea/*any' => redirect('/open-events')
  match '/racearea/*any' => redirect('/open-events')
  match '/live/winWebcam.asp' => redirect('/')
  match '/entryonline*any' => redirect('/open-events')
  match '/golf*any' => redirect('/howth-area')
  match '/hospitality/*any.asp' => redirect('/hospitality')

  match '/:controller(/:action(/:id))'
 # match '/reshyc/*'=>'pages#reroute'
  match '*path' => 'pages#catchall'
end
