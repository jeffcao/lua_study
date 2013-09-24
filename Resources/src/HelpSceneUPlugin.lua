HelpSceneUPlugin = {}

function HelpSceneUPlugin.bind(theClass)

	function theClass:createScrollView()
		local help_text = "简介：\"斗地主\"是一款最初流行于湖北三人扑克游戏，两个农民联合对抗一名地主，由于其规则简单、娱乐性强，迅速风靡全国。该游戏引进豆子为积分，增加了游戏的刺激性、变化性、让玩家休闲之余更享竟技的乐趣。\n1、发牌\n一副牌54张，一人17张，留3张做底牌，在确定地主之前玩家不能看底牌。\n2、叫牌\n叫牌按出牌的顺序轮流进行，每人只能叫一次。叫牌时可以叫“1分”，“2分”，“3分”，“不叫”。后叫牌者只能叫比前面玩家高的分或者不叫。叫牌结束后所叫分值最大的玩家为地主；如果有玩家叫“3分”则立即结束叫牌，该玩家为地主；如果都不叫，则重新发牌，重新叫牌。\n3、胜负判定\n任意一家出完牌后结束游戏，若是地主先出完牌则地主胜，否则另外两家胜。游戏采用传统的斗地主规则，添加了部分道具，使玩家游戏竟技过程中轻松乐趣，同时游戏设置了一些奖励，更增强了游戏的趣味性。"
	
		local container = display.newLayer()
		
		local help = CCLabelTTF:create()
		help:setString(help_text)
		help:setColor(ccc3(67,31,24))
		help:setFontSize(20.0)
		help:setDimensions(CCSizeMake(660,400))
		
		local scroll_view = CCScrollView:create()
		scroll_view:setViewSize(CCSizeMake(660,300))
		scroll_view:setContainer(help)
		scroll_view:setContentOffset(ccp(0,-100))
		scroll_view:setPosition(ccp(75,70))
		scroll_view:setDirection(kCCScrollViewDirectionVertical)
		scroll_view:setBounceable(true)
		return scroll_view
	end
	
end