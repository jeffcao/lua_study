require "src.HallPlugin"

HallScene = class("HallScene", function() 
	print("create new hall scene")
	return display.newScene("HallScene")
	end
 )
 
 function createHallScene()
 	print("createHallScene()")
 	return HallScene.new()
 end
 
 HallPlugin.bind(HallScene)
 
 function HallScene:ctor()
 	self.ccbproxy = CCBProxy:create()
 	self.ccbproxy:retain()
 	
 	local node = self.ccbproxy:readCCBFromFile("HallScene.ccbi")
	assert(node, "failed to load hall scene")
	self.rootNode = tolua.cast(node, "CCLayer")
	print("hall scene self.rootNode ==> ", self.rootNode)
	self:addChild(self.rootNode)

 end
 