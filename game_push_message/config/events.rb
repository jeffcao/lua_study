WebsocketRails::EventMap.describe do
  # You can use this file to map incoming events to controller actions.
  # One event can be mapped to any number of controller actions. The
  # actions will be executed in the order they were subscribed.
  #
  # Uncomment and edit the next line to handle the client connected event:
  #   subscribe :client_connected, :to => Controller, :with_method => :method_name
  #
  # Here is an example of mapping namespaced events:
  #   namespace :product do
  #     subscribe :new, :to => ProductController, :with_method => :new_product
  #   end
  # The above will handle an event triggered on the client like `product.new`.
  namespace :ui do
    subscribe :get_sys_msg, :to => MessageController, :with_method => :get_sys_msg
    subscribe :check_connection,  :to => BaseController, :with_method => :check_connection   #判断用户合法不
    subscribe :restore_connection,  :to => BaseController, :with_method => :restore_connection   #断线重链接
  end

  subscribe :client_error, :to => BaseController, :with_method => :on_client_error
  subscribe :client_disconnected, :to => BaseController, :with_method => :on_client_disconnected
  subscribe :client_connected, :to => BaseController, :with_method => :on_client_connected
end
