require 'src.ShouchonglibaoDonghua'

ShouChongPlugin = {}

function ShouChongPlugin.bind(theClass)
	function theClass:initShouchonglibao()
	 	print("HallScene:initShouchonglibao, GlobalSetting.shouchong_finished=", GlobalSetting.shouchong_finished)
	 	if GlobalSetting.shouchong_finished == 1 then
	 		self.hall_shouchong_layer:setVisible(false)
	 		if GlobalSetting.shouchong_rank_changed then
	 			if self.rank_dialog then
					self.rank_dialog:dismiss(true)
					self.rank_dialog = nil
				end
	 		end
	 	else
	 		self.hall_shouchong_layer:setVisible(true)
	 		ShouchonglibaoDonghua.show(self.hall_shouchong_layer, ccpAdd(
	 				ccp(self.hall_shouchonglibao_menu:getPosition()),
	 				ccp(-4, 2)))
	 	end
 	end
 	
 	function theClass:on_shouchonglibao_finished()
		print("HallSceneUPlugin.on_shouchonglibao_finished ")
		self.hall_shouchong_layer:setVisible(false)
		if self.rank_dialog then
			self.rank_dialog:dismiss(true)
			self.rank_dialog = nil
		end
	end
	
	function theClass:on_shouchong_click()
		local product = GlobalSetting.cache_prop["shouchongdalibao"]
		dump(product, "HallSceneUPlug.on_shouchong_click, product=> ")
		PurchasePlugin.show_buy_shouchonglibao(product)
		
--		GlobalSetting.shouchong_finished = 1
--		self.hall_shouchong_layer:setVisible(false)
		print("HallSceneUPlugin.on_shouchong_click.")
	end
end