CardUtility = {}


------------------------------------------------------------------------------
 -- 根据提供的牌，计算出牌型, 返回类型： Card card.card_type 为所属牌型， 当等于 CardType.None 表示无效牌型
 -- card.max_poke_value 牌型中的最大牌值，如单顺中的最大牌值 card.card_length
 -- 牌型个数，如单顺、双顺、三顺的个数，飞机中三顺的个数。
 -- 
 ------------------------------------------------------------------------------
CardUtility.getCard = function(poke_cards)
	
	local poke_count = #poke_cards
	cclog("poke_count"..poke_count)
	local card = Card.new()
	card.card_type = CardType.NONE -- 无效牌型
	card.poke_cards = poke_cards
	
	if not poke_cards or #poke_cards == 0 then
		return card
	end
	
	table.sort(poke_cards, function(x, y)
			return x.poke_value < y.poke_value
		end)
	
	for _, poke_card in pairs(poke_cards) do
		cclog("poke: poke_value " .. poke_card.poke_value .. " , poke_card_type: " .. 
				poke_card.poke_card_type .. " , poke_id: " .. poke_card.poke_id )
	end

	if poke_count == 1 then
		card.card_type = CardType.SINGLE
		card.max_poke_value = poke_cards[1].poke_value
		card.card_length = 1
		
		return card
	end
	
	-- 2张, 可能是对子或火箭(王炸)
	if poke_count == 2 then
		local result = CardUtility.isPairs(card) or CardUtility.isRocket(card)

		return card
	end 
	
	-- 可能是3张
	if poke_count == 3 then
		CardUtility.isThree(card)
		
		return card
	end 
	
	-- 4张, 可能是炸弹或三带一
	if poke_count == 4 then
		local result = CardUtility.isBomb(card) or CardUtility.isThreeWithOne(card)
		
		return card
	end 
	
	-- 5张 是否为三带一对
	if poke_count == 5 then
		if CardUtility.isThreeWithPairs(card) then
			return card
		end
	end
	
	-- 5张以上, 判断是否单顺
	if poke_count >= 5 then 
		if CardUtility.isStraight(card.poke_cards) then
			card.card_type = CardType.STRAIGHT
			card.max_poke_value = poke_cards[poke_count].poke_value
			card.card_length = #card.poke_cards
			
			return card
		end
	end

	-- 六张, 可能牌型 4带2单张
	if poke_count == 6 then
		if CardUtility.isFourWithTwo(card) then
			return card
		end
	end
	
	-- 六张以上, 可能双顺, 三顺, 飞机
	if poke_count >= 6 then
		if CardUtility.isPairsStraight(card) or CardUtility.isThreeStraight(card) then
			return card
		end
	end 
	
	-- 当牌数大于等于8,且能够被4整除时,判断是不是飞机, 或4带2对子
	if poke_count >=8 and poke_count % 4 == 0 then
		if CardUtility.isPlane(card) or CardUtility.isFourWithTwoPairs(card) then
			return card
		end
	end
	
	-- 当牌数大于等于10,且能够被5整除时,判断是不是飞机带翅膀
	if poke_count >=10 and poke_count % 5 == 0 then
		if CardUtility.isPlaneWithWing(card) then
			return card
		end
	end

	-- 返回无效牌型
	return card	
end

CardUtility.compare = function(card_a, card_b)
	if card_a == nil or card_b == nil then
		cclog("[CardUtility.compare] card_a = nil or card_b = nil")
		return false
	end
	
	if card_a.is_min_card then
		cclog("card_a is min card, return false")
		return false
	elseif card_b.is_min_card then
		cclog("card_b is min card, return true")
		return true
	end
	
-- card_a.--dumpPokeStrings()
-- card_b.--dumpPokeStrings()
	
	if card_a.card_type == CardType.ROCKET then
		cclog("[CardUtility.compare] card_a is rocket.")
		return true
	end
	
	if card_b.card_type == CardType.ROCKET then
		cclog("[CardUtility.compare] card_b is rocket.")
		return false
	end
	
	if card_a.card_type == CardType.NONE or card_b.card_type == CardType.NONE then
		cclog("[CardUtility.compare] card_a or card_b is invalid")
		return false
	end
	
	if card_a.card_type ~= card_b.card_type then
		print("[CardUtility.comapre] card_a.card_type => " , card_a.card_type , " , card_b.card_type => " , card_b.card_type)
		if card_a.card_type == CardType.BOMB then
			return true
		end
		return false
	end
	
	if #card_a.poke_cards ~= #card_b.poke_cards then
		return false
	end
	
	return card_a.max_poke_value > card_b.max_poke_value
end

--检查牌是否为顺牌, 不判断牌数，不同于判断顺子(顺子要求至少5张)
CardUtility.isStraight = function(poke_cards)
	for n, _ in pairs(poke_cards) do
		cclog("[isStraight] n => " .. n .. ", poke_value => " .. poke_cards[n].poke_value)
	end

	-- 顺牌的最大牌值不能大于A
	if poke_cards[#poke_cards].poke_value > PokeCardValue.ACE then
		return false
	end
	
	--LUA_CHANGE
	local start = nil
	-- 循环检查所有牌，每张牌必须比前一张大1
	for index, _ in pairs(poke_cards) do
		if start then
			cclog("poke_cards[" .. index .. "].poke_value => " .. poke_cards[index].poke_value )
			if start ~= poke_cards[index].poke_value - 1 then
				return false
			end
		end
		start = poke_cards[index].poke_value
		cclog("start => " .. start)
	end
	
	-- 符合顺牌规则
	return true
end

CardUtility.getPokeCount = function(poke_cards, index)
	local poke_card = poke_cards[index]
	local count = 0
	for n, _ in pairs(poke_cards) do
		local tmp_card = poke_cards[n]
		if tmp_card.poke_value == poke_card.poke_value then
			count = count + 1
		end
	end
	
	cclog("[CardUtility.getPokeCount] poke_card " .. poke_card.poke_value .. " , count => " .. count )
	
	return count
end

--检查对子
CardUtility.isPairs = function(card)
	cclog("[CardUtility.isPairs] #card.poke_cards => " .. #card.poke_cards)
	-- 取出牌
	local poke_cards = card.poke_cards
	-- 牌数必须为2
	if #poke_cards ~= 2 then
		return false
	end
	-- 牌值必须相同
	if poke_cards[1].poke_value == poke_cards[2].poke_value then
		-- 符合条件，标设为对子，和最大牌值
		card.card_type = CardType.PAIRS
		card.max_poke_value = poke_cards[1].poke_value
		card.card_length = 1
		
		return true
	end

	-- 不是对子
	return false
end

--检查火箭
CardUtility.isRocket = function(card)
	cclog("[CardUtility.isRocket] #card.poke_cards => " .. #card.poke_cards)
	-- 取出牌
	local poke_cards = card.poke_cards
	-- 牌数必须为2
	if #poke_cards ~= 2 then
		return false
	end
	-- 牌值必须是大小王
	if poke_cards[1].poke_value == PokeCardValue.SMALL_JOKER and
			poke_cards[2].poke_value == PokeCardValue.BIG_JOKER then
		-- 符合条件，标设为火箭，和最大牌值
		card.card_type = CardType.ROCKET
		card.max_poke_value = poke_cards[1].poke_value
		card.card_length = 1
		return true
	end
	
	return false
end

--检查三张
CardUtility.isThree = function(card)
	cclog("[CardUtility.isThree] #card.poke_cards => " .. #card.poke_cards)
	-- 取出牌
	local poke_cards = card.poke_cards
	-- 牌数必须为3
	if #poke_cards ~= 3 then
		return false
	end
	-- 三张的牌值必须相同
	if poke_cards[1].poke_value == poke_cards[2].poke_value and
			poke_cards[1].poke_value == poke_cards[3].poke_value then
		-- 符合条件，标设为三张，和最大牌值
		card.card_type = CardType.THREE
		card.max_poke_value = poke_cards[1].poke_value
		card.card_length = 1

		return true
	end
	
	return false
end

--检查三带一, 条件：前三张或后三张的牌值必须相同, 如 3-7-7-7 或 7-7-7-9
CardUtility.isThreeWithOne = function(card)
	cclog("[CardUtility.isThreeWithOne] #card.poke_cards => " .. #card.poke_cards)
	-- 取出牌
	local poke_cards = card.poke_cards
	-- 牌数必须为4
	if #poke_cards ~= 4 then
		return false
	end
	-- 前三张的牌值必须相同?
	if poke_cards[1].poke_value == poke_cards[2].poke_value and 
			poke_cards[1].poke_value == poke_cards[3].poke_value then
		-- 符合条件，标设为三张，和最大牌值
		card.card_type = CardType.THREE_WITH_ONE
		card.max_poke_value = poke_cards[1].poke_value
		card.card_length = 4
	 -- 或者后三张的牌值必须相同?
	elseif (poke_cards[2].poke_value == poke_cards[3].poke_value and 
			poke_cards[2].poke_value == poke_cards[3].poke_value) then
		-- 符合条件，标设为三张，和最大牌值
		card.card_type = CardType.THREE_WITH_ONE
		card.max_poke_value = poke_cards[2].poke_value
		card.card_length = 4
	end
	
	return (card.card_type ~= CardType.NONE)
end

--检查三带一对, 条件：5张牌， 三张 + 对子
CardUtility.isThreeWithPairs = function(card)
	--dump("[CardUtility.isThreeWithPairs] #card.poke_cards => " , card.poke_cards)
	-- 取出牌
	local poke_cards = card.poke_cards
	-- 牌数必须为5
	if (#poke_cards ~= 5) then
		return false
	end
	-- 有3张的牌值相同， 和2张相同
	local has_three = false
	local has_two = false
	local three_index = 0
	for n, _ in pairs(poke_cards) do
		local count = CardUtility.getPokeCount(poke_cards, n)
		if (count == 3) then
			has_three = true
			three_index = n
		elseif (count == 2) then
			has_two = true
		end
	end
	
	-- 是否三带一对
	if (has_three and has_two) then
		-- 符合条件，标设为三带一对，和最大牌值
		card.card_type = CardType.THREE_WITH_PAIRS
		card.max_poke_value = poke_cards[three_index].poke_value
		card.card_length = 1
		return true
	end
	
	return false		
end

--检查炸弹， 条件：四张牌一样
CardUtility.isBomb = function(card)
	cclog("[CardUtility.isBomb] #card.poke_cards => " .. #card.poke_cards)
	-- 取出牌
	local poke_cards = card.poke_cards
	-- 牌数必须为4
	if (#poke_cards ~= 4) then
		return false
	end
	-- 4张的牌值必须相同?
	if (poke_cards[1].poke_value == poke_cards[2].poke_value and 
			poke_cards[1].poke_value == poke_cards[3].poke_value and
			poke_cards[1].poke_value == poke_cards[4].poke_value) then
		-- 符合条件，标设为炸弹，和最大牌值
		card.card_type = CardType.BOMB
		card.max_poke_value = poke_cards[1].poke_value
		card.card_length = 1
		
		return true
	end
	
	return false
end

--检查4带2，条件：有四张相同
CardUtility.isFourWithTwo = function(card)
	cclog("[CardUtility.isFourWithTwo] #card.poke_cards => " .. #card.poke_cards)
	-- 取出牌
	local poke_cards = card.poke_cards
	-- 牌数必须为4
	if (#poke_cards ~= 6) then
		return false
	end
	-- 有4张的牌值相同?
	local has_four = false
	local four_index = 0
	for n, _ in pairs(poke_cards) do
		local count = CardUtility.getPokeCount(poke_cards, n)
		if (count == 4) then
			has_four = true
			four_index = n
		end
	end
	
	-- 是否4带2
	if (has_four) then
		-- 符合条件，标设为四带二，和最大牌值
		card.card_type = CardType.FOUR_WITH_TWO
		card.max_poke_value = poke_cards[four_index].poke_value
		card.card_length = 1
		return true
	end
	
	return false
end

--检查4带2对，条件：8张， 有四张相同， 另外4张为2个对子
CardUtility.isFourWithTwoPairs = function(card)
	cclog("[CardUtility.isFourWithTwoPairs] #card.poke_cards => " .. #card.poke_cards)
	-- 取出牌
	local poke_cards = card.poke_cards
	-- 牌数必须为8
	if (#poke_cards ~= 8) then
		return false
	end
	-- 有4张的牌值相同?
	local has_four = false
	local four_index = 0
	local two_pairs_array = {}
	for n,_ in pairs(poke_cards) do
		local count = CardUtility.getPokeCount(poke_cards, n)
		if (count == 4) then
			has_four = true
			four_index = n
		end
		if (count == 2) then
			table.insert(two_pairs_array, poke_cards[n])
		end
	end

	local uniq_two_pairs_array = table.unique( two_pairs_array, 
		function(elem) return elem.poke_value end )

	-- 是否4带2对
	if (has_four and #uniq_two_pairs_array == 2) then
		-- 符合条件，标设为四带二对，和最大牌值
		card.card_type = CardType.FOUR_WITH_TWO_PAIRS
		card.max_poke_value = poke_cards[four_index].poke_value
		card.card_length = 1
		return true
	end
	
	return false
end

--检查飞机， 条件： 大于等于8张牌，能被4整除，有三顺
CardUtility.isPlane = function(card)
	cclog("[CardUtility.isPlane] #card.poke_cards => " .. #card.poke_cards)
	-- 取出牌
	local poke_cards = card.poke_cards
	-- 牌数必须 大于8张牌，能被4整除
	if ( not (#poke_cards >=8 and (#poke_cards % 4 == 0)) ) then
		return false
	end
	local three_cards = {}
	for n,_ in pairs(poke_cards) do
		local count = CardUtility.getPokeCount(poke_cards, n)
		if (count == 3) then
			table.insert(three_cards, poke_cards[n])
		end
	end
	
	-- 剔除重复的牌
	three_cards = table.unique(three_cards, function(obj) return obj.poke_value end )
	-- 三张的个数必须等于牌数整除4
	if (#three_cards * 4 ~= #poke_cards ) then
		return false
	end
	-- 三张必须是顺子
	if (CardUtility.isStraight(three_cards)) then
		-- 符合条件，标设为飞机，和最大牌值为三顺的最大牌
		card.card_type = CardType.PLANE
		card.max_poke_value = three_cards[#three_cards].poke_value
		card.card_length = #three_cards
		
		return true
	end
	
	return false
end

--检查飞机带翅膀， 条件： 大于等于10张牌，能被5整除，有三顺 和 余下全是对子
CardUtility.isPlaneWithWing = function(card)
	cclog("[CardUtility.isPlaneWithWing] #card.poke_cards => " .. #card.poke_cards)
	-- 取出牌
	local poke_cards = card.poke_cards
	-- 牌数必须 大于等于10张牌，能被5整除
	if ( not (#poke_cards >=10 and (#poke_cards % 5 == 0)) ) then
		return false
	end
	local three_cards = {}
	local pairs_cards = {}
	for n,_ in pairs(poke_cards) do
		local count = CardUtility.getPokeCount(poke_cards, n)
		if (count == 3) then
			table.insert(three_cards, poke_cards[n])
		end
		if (count == 2) then
			table.insert(pairs_cards, poke_cards[n])
		end
	end
	
	-- 剔除重复的牌
	three_cards = table.unique(three_cards, function(obj) return obj.poke_value end)
	pairs_cards = table.unique(pairs_cards, function(obj) return obj.poke_value end)
	-- 三张的个数和对子的个数必须等于牌数整除5,
	if ( (#three_cards ~= (#poke_cards / 5)) or
			(#pairs_cards ~= (#poke_cards / 5) ) ) then
		return false
	end
	-- 三张必须是顺子
	if (CardUtility.isStraight(three_cards)) then
		-- 符合条件，标设为飞机，和最大牌值为三顺的最大牌
		card.card_type = CardType.PLANE_WITH_WING
		card.max_poke_value = three_cards[#three_cards].poke_value
		card.card_length = #three_cards
		
		return true
	end
	
	return false
end

--检测双顺， 条件：牌数>=6, 全是连续的对子，且不含2
CardUtility.isPairsStraight = function(card)
	cclog("[CardUtility.isPairsStraight] #card.poke_cards => " .. #card.poke_cards)
	-- 取出牌
	local poke_cards = card.poke_cards
	-- 牌数必须 大于6张牌，能被2整除
	if ( not (#poke_cards >=6 and (#poke_cards % 2 == 0)) ) then
		return false
	end
	
	local couple_cards = {}
	for n,_ in pairs(poke_cards) do
		local count = CardUtility.getPokeCount(poke_cards, n)
		if (count == 2) then
			table.insert(couple_cards, poke_cards[n])
		end
	end
	
	-- 剔除重复的牌
	local unique_cards = table.unique(couple_cards, function(obj) return obj.poke_value end )
	-- 对子数量必须为牌数/2
	if (#unique_cards * 2 ~= #poke_cards) then
		return false
	end
	
	-- 必须是顺牌
	if (CardUtility.isStraight(unique_cards)) then
		-- 符合条件，标设为双顺，和最大牌值为双顺的最大牌，及顺子对数
		card.card_type = CardType.PAIRS_STRAIGHT
		card.max_poke_value = unique_cards[#unique_cards].poke_value
		card.card_length = #unique_cards
		
		return true
	end
	
	return false
end

--检测三顺， 条件：牌数>=6, 全是连续的三张，且不含2
CardUtility.isThreeStraight = function(card)
	cclog("[CardUtility.isThreeStraight] #card.poke_cards => " .. #card.poke_cards)
	-- 取出牌
	local poke_cards = card.poke_cards
	-- 牌数必须 大于6张牌，能被3整除
	if ( not (#poke_cards >=6 and (#poke_cards % 3 == 0)) ) then
		return false
	end
	
	local couple_cards = {}
	for n,_ in pairs(poke_cards) do
		local count = CardUtility.getPokeCount(poke_cards, n)
		if (count == 3) then
			table.insert(couple_cards, poke_cards[n])
		end
	end
	
	-- 剔除重复的牌
	local unique_cards = table.unique(couple_cards, function(obj) return obj.poke_value end)
	
	-- 剔除重复的牌
	local unique_cards = table.unique(poke_cards, function(obj) return obj.poke_value end)
	-- 对子数量必须为牌数/3
	if (#unique_cards * 3 ~= #poke_cards) then
		return false	
	end
	
	-- 必须是顺牌
	if (CardUtility.isStraight(unique_cards)) then
		-- 符合条件，标设为三顺，和最大牌值为三顺的最大牌，及顺子对数
		card.card_type = CardType.THREE_STRAIGHT
		card.max_poke_value = unique_cards[#unique_cards].poke_value
		card.card_length = #unique_cards
		
		return true
	end
	
	return false
end

CardUtility.slide_card = function(last_play_card, source_card, is_self_play, is_self_last_player)
	if (notis_self_play or is_self_last_player or not last_play_card) then
		-- 还没有人出过牌，正序选出一手牌
		-- 不该自己打牌的时候划牌，正序选出一手牌
		-- 该自己打牌，上一手牌是自己打出，只需要正序选出一手牌
		local str = ""
		if (not is_self_play) then
			str = "不该自己出牌划牌，"
		elseif is_self_last_player then
			str = "上一首牌是自己划牌，"
		else
			str = "还没有人出牌划牌，"
		end
		cclog(str .. "正序选出一手牌")
		return CardUtility.get_tip_card(source_card)
	else
		-- 该自己打牌，并且上一手牌不是自己打出的，需要选一手压过上家的牌，压不过，返回空
		cclog("该自己打牌划牌，并且上一手牌不是自己打出的，需要选一手压过上家的牌，压不过，返回空")
		return CardUtility.get_larger(last_play_card, source_card)
	end 
end

CardUtility.tip_card = function(last_play_card, source_card, is_self_last_player)
	dump(last_play_card, "CardUtility.tip_card, last_play_card=")
	dump(source_card, "CardUtility.tip_card, source_card=")
	dump(is_self_last_player, "CardUtility.tip_card, is_self_last_player=")
	if (is_self_last_player or not last_play_card) then
		-- 上一手牌是自己或自己是头一个出牌的，倒序选出一手牌
		local str = ""
		if (is_self_last_player) then
			str = "上一首牌是自己提示，"
		else
			str = "还没有人出牌提示，"
		end
		cclog(str .. "倒序选出一手牌")
		return CardUtility.get_tip_card(source_card, true)
	else
		-- 上一手牌不是自己，选一手可以压过的牌，压不过，返回空
		cclog("上一手牌不是自己提示，选一手可以压过的牌，压不过，返回空")
		return CardUtility.get_larger(last_play_card, source_card)
	end
end

-- 选一手可以压过的牌，压不过，返回空
CardUtility.get_larger = function(to_compare_card, source_card)
	for index,_ in pairs(source_card) do
		local card = source_card[index]
		print("source_card, card:" , card , ", poke_value:" , card.poke_value , ", card_type:" , card.card_type)
	end
	local single_cards = {}
	local pairs_cards = {}
    local three_cards = {}
    local four_cards = {}

    CardUtility.combine_pokes(source_card, four_cards, pairs_cards, single_cards, three_cards)
    local straight_cards = CardUtility.get_straight(clone_table(pairs_cards), clone_table(single_cards))
    print("straight_cards=>" , straight_cards)
    local pairs_straight_cards = CardUtility.get_pair_straight(clone_table(three_cards), clone_table(pairs_cards))
    print("pairs_straight_cards=>" , pairs_straight_cards)

    local result_card = {}
    dump(single_cards, "single_cards")
	dump(pairs_cards, "pairs_cards")
	dump(three_cards, "three_cards")
	dump(four_cards, "four_cards	")


	--CardTest.test_four_with_two()
	--CardTest.test_straight()
	
	local c_type = to_compare_card.card_type
	if c_type == CardType.NONE then
		return {}
		
	elseif c_type == CardType.SINGLE then
		result_card = CardUtility.get_larger_card_helper(single_cards, to_compare_card)
		
	elseif c_type == CardType.PAIRS then
		result_card = CardUtility.get_larger_card_helper(pairs_cards, to_compare_card)
		
	elseif c_type == CardType.PAIRS_STRAIGHT then
		result_card = CardUtility.get_larger_pairs_straight(pairs_straight_cards, to_compare_card)
		
	elseif c_type == CardType.THREE then
		result_card = CardUtility.get_larger_card_helper(three_cards, to_compare_card)
		
	elseif c_type == CardType.THREE_WITH_PAIRS then
		result_card = CardUtility.get_larger_three_with_one(three_cards, pairs_cards, to_compare_card)	
		
	elseif c_type == CardType.THREE_WITH_ONE then
		result_card = CardUtility.get_larger_three_with_one(three_cards, single_cards, to_compare_card)
		
	elseif c_type == CardType.THREE_STRAIGHT then
		cclog("card type is then " .. to_compare_card.card_type)
		
	elseif c_type == CardType.FOUR_WITH_TWO then
		result_card = CardUtility.get_larger_four_with_two(four_cards, single_cards, to_compare_card)
		
	elseif c_type == CardType.FOUR_WITH_TWO_PAIRS then
		--dump(pairs_cards, "CardType.FOUR_WITH_TWO_PAIRS:pairs_cards")
		result_card = CardUtility.get_larger_four_with_two(four_cards, pairs_cards, to_compare_card)
		
	elseif c_type == CardType.PLANE then
		cclog("card type is then " .. to_compare_card.card_type)
		
	elseif c_type == CardType.PLANE_WITH_WING then
		cclog("card type is then " .. to_compare_card.card_type)
		
	elseif c_type == CardType.STRAIGHT then
		result_card = CardUtility.get_larger_straight(straight_cards, to_compare_card)
		
	elseif c_type == CardType.BOMB then
		result_card = CardUtility.get_larger_card_helper(four_cards, to_compare_card)
		
	elseif c_type == CardType.ROCKET then
		return {}
		
	end
	
	if (#result_card == 0 and to_compare_card.card_type ~= CardType.BOMB) then
		result_card = CardUtility.get_larger_card_helper(four_cards, to_compare_card)
		if (#result_card == 0) then
			result_card = CardUtility.getRocket(source_card)
		end
	end
    return result_card
end

-- 选出一手牌, is_reverse不为空，倒序选择，否则正序选择
CardUtility.get_tip_card = function(source_card, is_reverse)
	--未加进去的优先顺序
	--THREE_STRAIGHT: 7,		-- 三张的顺子
	--FOUR_WITH_TWO: 8,		-- 四带二
	--FOUR_WITH_TWO_PAIRS: 9, -- 四带二对
	--PLANE_WITH_WING: 11,		-- 飞机带翅膀(三张带一对的顺子)
	--BOMB: 13,				-- 炸弹
	--ROCKET: 14
	local to_compare_card = Card.new()
	to_compare_card.is_min_card = true
	local seq = {CardType.FOUR_WITH_TWO_PAIRS, CardType.FOUR_WITH_TWO, CardType.STRAIGHT, CardType.PAIRS_STRAIGHT, CardType.PLANE, 
	           CardType.THREE_WITH_PAIRS, CardType.THREE_WITH_ONE, CardType.THREE, CardType.PAIRS, CardType.SINGLE}
	if (is_reverse) then
		seq = table.reverse(seq)
	end
	for index,_ in pairs(seq) do
		to_compare_card.card_type = seq[index]
		local result = CardUtility.get_larger(to_compare_card, source_card)
		--dump(result, "get_tip_card=>" .. seq[index] .. ":" )
		if (#result > 0) then
			return result
		end
	end
	
    return {}
end

CardUtility.combine_pokes = function(all_cards, four_cards, pairs_cards, single_cards, three_cards)
	local sort_cards = clone_table(all_cards)
	table.sort(sort_cards, 
		function(x, y)
			local xv = x.poke_value
			local yv = y.poke_value
			local result = xv < yv
			return result
		end)
	local tmp_cards = {}
	for index,_ in pairs(sort_cards) do
		local card = sort_cards[index]
		local need_push = true
	    if (#tmp_cards ==0 or card.poke_value == tmp_cards[#tmp_cards].poke_value) then
			need_push = false
		end
        if (index == #sort_cards) then
          if (#tmp_cards >0 and card.poke_value == tmp_cards[#tmp_cards].poke_value) then
            table.insert(tmp_cards, card)
          else
        	if (#tmp_cards == 1) then
        		table.insert(single_cards, clone_table(tmp_cards))
        	  	tmp_cards = {}
        	end
        	table.insert(single_cards, {card})
          end
          need_push = true
        end
        if need_push and #tmp_cards >0 then
          if (#tmp_cards == 1) then
          	table.insert(single_cards, clone_table(tmp_cards))
          elseif #tmp_cards == 2 then
          	table.insert(pairs_cards, clone_table(tmp_cards))
          elseif #tmp_cards == 3 then
          	table.insert(three_cards, clone_table(tmp_cards))
          elseif #tmp_cards == 4 then
          	table.insert(four_cards, clone_table(tmp_cards))
          end
          tmp_cards = {}
        end
        table.insert(tmp_cards,card)
	end
	--dump(single_cards, "single_cards")
	--dump(pairs_cards, "pairs_cards")
	--dump(three_cards, "three_cards")
	--dump(four_cards, "four_cards")
end

CardUtility.getRocket = function(cards)
	if(cards and #cards > 1)  then
		local sort_cards = clone_table(cards)
		table.sort(sort_cards, 
			function(x, y)
				local xv = x.poke_value
				local yv = y.poke_value
				local result = xv < yv
				return result
			end)
		print("get rocket, sort_cards:" , sort_cards)
		local l = #sort_cards
		local last = sort_cards[l]
		local last_s = sort_cards[l - 1]
		if (last.poke_value == 17 and last_s.poke_value == 16)  then
			cclog("return rocket")
			return {last, last_s}
		end
	end
	return {}
end

CardUtility.get_larger_card_helper = function(cards, s_card)
	for index,_ in pairs(cards) do
		local cur_card = cards[index]
		if (CardUtility.compare(CardUtility.getCard(cur_card), s_card)) then
			return cur_card
		end
	end
	return {}
end
	
CardUtility.get_larger_three_with_one = function(three_cards, single_cards, s_card)
	local one_card = nil
	if #single_cards > 0 then
		one_card = single_cards[1]
	end
	if (one_card and one_card[1].poke_value < 14) then
		for index,_ in pairs(three_cards) do
			local three = three_cards[index]
			local cards = clone_table(three)
			table.combine(cards, one_card)
			if (CardUtility.compare(CardUtility.getCard(cards), s_card)) then
				return cards
			end
		end
	end
	return {}
end

CardUtility.get_larger_four_with_two = function(four_cards, with_two_cards, s_card)
	--dump(four_cards, "get_larger_four_with_two four_cards")
	--dump(with_two_cards, "get_larger_four_with_two with_two_cards")
	local with_two_card = nil
	if #with_two_cards > 1 then
		with_two_card = {with_two_cards[1], with_two_cards[2]}
	end
	local skip = false
	if (with_two_card)  then
		for index,_ in pairs(with_two_card) do
			local card = with_two_card[index][1]
			
			if (card.poke_value > 14) then
				skip = true
			end
		end
	else
		skip = true
	end
	
	if (not skip)  then
		for index,n in pairs(four_cards) do
			local four = four_cards[index]
			local cards = clone_table(four)
			table.combine(cards, with_two_card[1])
			table.combine(cards, with_two_card[2])
			if (CardUtility.compare(CardUtility.getCard(cards), s_card))  then
				return cards
			end
		end
	end
	return {}
end

CardUtility.get_straight = function(pairs_cards, single_cards)
	local all_cards = {}
	for index,n in pairs(single_cards) do
		table.insert(all_cards, single_cards[index][1])
	end
	for index,n in pairs(pairs_cards) do
		table.insert(all_cards, pairs_cards[index][1])
	end
	local sort_cards = clone_table(all_cards)
	table.sort(sort_cards, function(x, y)
			local xv = x.poke_value
			local yv = y.poke_value
			local result = xv < yv
			return result
		end)
	--dump(sort_cards, "[get_straight] sort_cards =>")
	local tmp_cards = clone_table(sort_cards)	
	local straight_cards = {}
	local straight_card = {}
	
	for index,_ in pairs(sort_cards) do
		local card = sort_cards[index]
		table.insert(straight_card,card)
		local compare_card = card
		
		for index2,_ in pairs(tmp_cards) do
			local next_card = tmp_cards[index2]
			if(compare_card.poke_value + 1 == next_card.poke_value and next_card.poke_value < 15) then
				table.insert(straight_card,next_card)
				compare_card = next_card
			end
		end
		
		if (#straight_card > 4) then
			table.insert(straight_cards, clone_table(straight_card))
		end
		straight_card = {}
	end
	--dump(straight_cards, "straight_cards")
	return straight_cards
end

CardUtility.get_larger_straight = function(straight_cards, s_card)
	for index,_ in pairs(straight_cards) do
		local straight_card = straight_cards[index]
		if (CardUtility.compare(CardUtility.getCard(straight_card), s_card)) then
			return straight_card
		end
	end
	return {}
end

CardUtility.get_pair_straight = function(three_cards, pairs_cards)
	local all_cards = {}
	for index,_ in pairs(three_cards) do
		local card = three_cards[index]
		table.insert(all_cards, card[1])
		table.insert(all_cards, card[2])
	end
	for index,_ in pairs(pairs_cards) do
		local card = pairs_cards[index]
		table.insert(all_cards, card[1])
		table.insert(all_cards, card[2])
	end
	local sort_cards = clone_table(all_cards)
	table.sort(sort_cards, function(x, y) 
		local xv = x.poke_value
		local yv = y.poke_value
		local result = xv < yv
		return result
	end)
	
	print("[get_pair_straight] sort_cards =>", sort_cards)
	local tmp_cards = clone_table(sort_cards)
	local pairs_straight_cards = {}
	local pairs_straight_card = {}
	for index,_ in pairs(sort_cards) do
		local card = sort_cards[index]
		table.insert(pairs_straight_card, card)
		if(index%2 == 0) then
			local compare_card = card
			local tmp_pairs_cards = {}
			
			for index2,_ in pairs(tmp_cards) do
				local next_card = tmp_cards[index2]
				table.insert(tmp_pairs_cards, next_card)
				if(index2%2 == 0) then
					 if (compare_card.poke_value + 1 == next_card.poke_value) then
					 	table.combine(pairs_straight_card, tmp_pairs_cards)
			           	compare_card = next_card
					 end
			         tmp_pairs_cards = {}
				 end
			end
			if (#pairs_straight_card > 5) then
				table.insert(pairs_straight_cards, clone_table(pairs_straight_card))
			end
			pairs_straight_card = {}
		end
	end
	return pairs_straight_cards
end

CardUtility.get_larger_pairs_straight = function(pairs_straight_cards, s_card)
	
	for index,_ in pairs(pairs_straight_cards) do
		local straight_card = pairs_straight_cards[index]
		if(CardUtility.compare(CardUtility.getCard(straight_card), s_card)) then
			return straight_card
		end
	end
	return {}
end
	