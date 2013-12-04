require 'DialogInterface'

RestrictedDialog = {}

function RestrictedDialog.bind(theClass)
	
	DialogInterface.bind(theClass)
	
	theClass.old_show = theClass.show
	theClass.old_dismiss = theClass.dismiss

	function theClass:isShowRestricted()
		local last_show = GlobalSetting.last_show or -1
		return os.time() - last_show > 20
	end

	function theClass:setLastShow()
		GlobalSetting.last_show = os.time()
	end

	function theClass:show()
		if self:isShowRestricted() then return end
		self:old_show()
	end

	function theClass:dismiss()
		self:setLastShow()
		self:old_dismiss()
	end
end