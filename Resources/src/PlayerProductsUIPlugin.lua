PlayerProductsUIPlugin = {}

function PlayerProductsUIPlugin.bind(theClass)

function theClass:show_product_list(data)
	print("[PlayerProductsScene:show_product_list]")
	if self.product_view then
		self.rootNode:removeChild(self.product_view, true)
	end
	self.product_view = self:create_product_list(data.cats)
	if self.product_view then
		self.rootNode:setContent(self.product_view)
	end
end


function theClass:init_product_list()
	print("[PlayerProductsScene:init_product_list]")
	
	self:show_progress_message_box("获取道具列表...")
	self.after_trigger_success = __bind(self.show_product_list, self)
	self:cate_list()
	
	
end

function theClass:after_use_product(data)
	print("[PlayerProductsScene:after_use_product]")
	if tostring(data.prop.prop_count) ~= "0" then
		self.use_prop_callback(data.prop.prop_count)
	else
		self:init_product_list()
	end
	
end

function theClass:show_use_notify(product, use_prop_callback)
	print("[PlayerProductsScene:do_on_trigger_success]")
	self.use_prop_callback = use_prop_callback
	self:show_progress_message_box("发送道具使用请求...")
	self:use_cate(product.prop_id)
	self.after_trigger_success = __bind(self.after_use_product, self)
end


function theClass:do_on_trigger_success(data)
	print("[PlayerProductsScene:do_on_trigger_success]")
	self:hide_progress_message_box()
	print("[PlayerProductsScene:do_on_trigger_success] after_trigger_success=> "..type(self.after_trigger_success))
	if "function" == type(self.after_trigger_success) then
		local fn = self.after_trigger_success
		self.after_trigger_success = nil
		fn(data)
		
	end
	
end

function theClass:do_on_trigger_failure(data)
	print("[MarketSceneUPlugin:do_on_trigger_failure]")
	self:hide_progress_message_box()
	self:show_message_box(self.failure_msg)
	if "function" == type(self.after_trigger_failure) then
		self.after_trigger_failure(data)
		self.after_trigger_failure = nil
	end
end

end
