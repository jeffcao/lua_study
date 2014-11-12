DdzAdminServer::Application.routes.draw do
  devise_for :super_users

  ActiveAdmin.routes(self)
  root :to => "supper_user#sign_in"
  #resources :my_test
  match 'chart' => "Chart#index", :via => [:post, :get]

  match 'get_data' => "DataForOa#get_data", :via => [:post, :get]
  match '/admin/special_match_arrangements/new' => 'admin/GameView#game_view'
  match '/admin/market_counts' => 'MarketCounts#index'
  match '/admin/user_consume_lists/list' => 'admin/UserConsumeLists#index',:via => [:post,:get]
  match '/admin/market_counts/list' => 'admin/MarketCounts#index',:via => [:post,:get]
  match '/admin/personal_get_mobile_charges/list' => 'admin/PersonalGetMobileCharges#index',:via => [:post,:get]
  match '/admin/distribute_mobile_charges/cx' => 'admin/DistributeMobileCharges#index',:via => [:post,:get]

  match '/admin/game_view' => 'admin/GameView#game_view'
  match '/admin/view' => 'admin/GameView#view'
  match '/admin/online_players' => 'admin/GameView#online_players'
  match '/admin/game_tables' => 'admin/GameView#game_tables'
  match '/admin/room_msg' => 'admin/GameView#room_msg'
  match '/admin/table_user' => 'admin/GameView#table_user'
  match '/admin/login_log' => 'admin/GameView#login_log'
  match '/admin/charge_user' => 'admin/GameView#charge_user'
  match '/admin/product_map' => 'admin/GameView#product_map'
  match '/admin/product_item' => 'admin/GameView#product_item'
  match '/admin/visit_count' => 'admin/GameView#visit_count'
  match '/admin/bean_distribution' => 'admin/GameView#bean_distribution'
  match '/admin/apk_signature_public_keys/:id' => 'admin/apk_signature_public_keys#test'
  match '/admin/edit_apk/:id' => 'admin/apk_updates#apk_update',:via => [:post,:get]
  match '/admin/tuisong' => 'admin/ml_tests#tuisong'
  match '/admin/bj' => 'admin/ml_tests#action'
  match 'admin/action' => 'admin/ml_tests#action'
  match 'admin/tt' => 'admin/ml_tests#tt'
  match 'admin/prop_list' => 'Prop#prop_list'
  match 'admin/enable_consume_code' => 'Prop#enable_consume_code',:via => [:post,:get]
  match 'admin/new_msg' => 'admin/ml_tests#new_msg',:via => [:post,:get]
  match '/admin/ddz_baobiaos/cx' => 'admin/ddz_baobiaos#index',:via => [:post,:get]
  match '/admin/partner_baobiaos/cx' => 'admin/partner_baobiaos#index',:via => [:post,:get]
  match '/admin/every_hour_huo_yue_users/cx' => 'admin/every_hour_huo_yue_users#index',:via => [:post,:get]
  match '/admin/huo_yue_user_tu_shis/cx' => 'admin/huo_yue_user_tu_shis#index',:via => [:post,:get]

  match '/admin/partner_baobiaos/new' => 'admin/partner_baobiaos#index',:via => [:post,:get]
  match '/admin/user_credit_setups' => 'UserCreditSetups#index',:via => [:post,:get]
  match '/admin/user_mobile_source/cx' => 'UserMobileSource#cx',:via => [:post,:get]
  #match '/admin/cx' => 'admin/pay_mobiles#index',:via => [:post,:get]
  match '/admin/pay_mobiles' => 'admin/PayMobile#index',:via => [:post,:get]


  #match 'admin/system_messages' => 'admin/SystemMessage#game_view'

  #match '/admin/apk_signature_public_keys/:id' => 'admin/ApkSignaturePublicKey#test'
  #match '/admin/apk_signature_public_keys' => 'admin/GameView#game_view'



  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
