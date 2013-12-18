
function scaleNode(node, scaleFactor)
	local node = tolua.cast(node, "CCNode")
	if node:getTag() >= 1000 then
		node:setScale(scaleFactor)
	end
	
	if node:getChildrenCount() > 0 then
		local children = node:getChildren()
		for index = 0, children:count()-1 do
			local child = children:objectAtIndex(index)
			scaleNode(child, scaleFactor)
		end
	end
	
end

function endtolua_guifan()
	local scene = createGuifanEndScene()
	CCDirector:sharedDirector():pushScene(scene)
end

function endtolua()
	--local jni_helper = DDZJniHelper:create()
	--jni_helper:messageJava("RecoveryMusicVolume")
	CCDirector:sharedDirector():endToLua()
end

function table.filter(src, fn)
	local result = {}
	for _,v in pairs(src) do
		if fn(v) then
			table.insert(result, v)
		end
	end
	return result
end

function table.combine(dest, src)
	for _, value in pairs(src) do
		table.insert(dest, value)
	end
end

function table.copy_kv(dest, src)
	for k,v in pairs(src) do
		dest[k] = v
	end
end

function clone_table(array)
	local result = {}
	table.merge(result, array)
	return result
end

function table.join(table, s)
	s = tostring(s)
	local str = ""
	for _, _v in pairs(table) do
		if str == "" then 
			str = str .. tostring(_v)
		else 
			str = str .. s .. tostring(_v)
		end
	end
	return str
end

function table.toString(table)
	local str = "[ "
	for _, _v in pairs(table) do
		str = str .. tostring(_v) .. ",  "
	end
	str = str .. "]"
	return str
end

function table.reverse(array)
	local result = {}
	for index = -#array, -1 do
		table.insert(result, array[-index])
	end
	return result
end

function table.some(array, func)
	local result = false
	for _, obj in pairs(array) do
		if func(obj) then
			result = true
			break
		end
	end
	return result
end

function table.unique(array, getObjectValueFuc)
	local newArray = {}
	for elementIndex,_ in pairs(array) do
		local elementValue = getObjectValueFuc(array[elementIndex])
		local search = function(obj) return (getObjectValueFuc(obj) == elementValue) end
		local exist = table.some(newArray, search)
		if not exist then
			table.insert(newArray, array[elementIndex])
		end
	end
	return newArray
end

function is_blank(str)
	return str == nil or string.len(string.trim(str)) == 0
end

function trim_blank(s)
 	local from = s:match"^%s*()"
 	return from > #s and "" or s:match(".*%S", from)
end

function string_to_array(s)
	local len = string.len(s)
	local arr = {}
	for i=1,len do
		table.insert(arr, string.sub(s,i,i))
	end
	return arr
end

function split(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
	 table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   
   return t
end

function trim(str, char)
	local return_value = str
	local char_index = string.find(str, char)
	if char_index == 1 then
		return_value = str:sub(2)	
	end
	
	char_index = string.find(return_value, char, -1)
	if char_index == #return_value then
		return_value = return_value:sub(1, #return_value-1)	
	end
	return return_value
end

function sleep(n)
  os.execute("sleep " .. tonumber(n))
end

function isnan(x) 
    if (x ~= x) then
        --print(string.format("NaN: %s ~= %s", x, x))
        return true --only NaNs will have the property of not being equal to themselves
    end

    --but not all NaN's will have the property of not being equal to themselves

    --only a number can not be a number
    if type(x) ~= "number" then
       return false 
    end

    --fails in cultures other than en-US, and sometimes fails in enUS depending on the compiler
--  if tostring(x) == "-1.#IND" then

    --Slower, but works around the three above bugs in LUA
    if tostring(x) == tostring((-1)^0.5) then
        --print("NaN: x = sqrt(-1)")
        return true 
    end

    --i really can't help you anymore. 
    --You're just going to have to live with the exception

    return false
end

function check_email(email)
	if (email:match("[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?")) then
		return true
	end
	return false
end

function device_info()
	local userDefault = CCUserDefault:sharedUserDefault()
	local device_info = {
		imei = userDefault:getStringForKey("hw_imei"),
		mac = userDefault:getStringForKey("hw_mac"),
		imsi = userDefault:getStringForKey("hw_imsi"),
		brand = userDefault:getStringForKey("hw_brand"),
		model = userDefault:getStringForKey("hw_model"),
		os_release = userDefault:getStringForKey("hw_version"),
		manufacture = userDefault:getStringForKey("hw_manufacture"),
		cpu_abi = userDefault:getStringForKey("hw_cpu_abi"),
		board = userDefault:getStringForKey("hw_board"),
		device = userDefault:getStringForKey("hw_device"),
		product = userDefault:getStringForKey("hw_product"),
		display = userDefault:getStringForKey("hw_display"),
		id = userDefault:getStringForKey("hw_id"),
		appid = userDefault:getStringForKey("appid"),
		pkg_version_name = userDefault:getStringForKey("pkg_version_name"),
		pkg_version_code = userDefault:getStringForKey("pkg_version_code"),
		pkg_build = userDefault:getStringForKey("pkg_build"),
		pkg_resource_version = resource_version
	}
	if is_blank(device_info.pkg_resource_version) then
		device_info.pkg_resource_version = device_info.pkg_version_name
	end
	CheckSignLua:fix_sign_param(device_info)
	--for test
	--if GlobalSetting.run_env == "test" then
	--	device_info.pkg_resource_version = "1.7"
	--end
	return device_info
end

local levels_hanzi = {
"短工",
"长工",
"佃户",
"贫农",
"渔夫",
"猎人",
"中农",
"富农",
"掌柜",
"商人",
"衙役",
"小财主",
"大财主",
"小地主",
"大地主",
"知县",
"通判",
"知府",
"总督",
"巡抚",
"丞相",
"侯爵",
"亲王",
"明君",
"仁主"}

local levels_pinyin = {
"duangong",
"changgong",
"tianhu",
"pinnong",
"yufu",
"lieren",
"zhongnong",
"funong",
"zhanggui",
"shangren",
"yayi",
"xiaocaizhu",
"dachaizhu",
"xiaodizhu",
"dadizhu",
"zhixian",
"tongpan",
"zhifu",
"zhongdu",
"xunfu",
"chengxiang",
"houjue",
"qinwang",
"mingjun",
"renzhu"}


function get_level_pic(level_hanzi)
	local level = "duangong"
	if level_hanzi then
		for k,v in pairs(levels_hanzi) do
			if v==level_hanzi then
				level = levels_pinyin[k]
				break
			end
		end
	end
	cclog("level pic is " .. level .. ".png")
	return level .. ".png"
end

function set_level_sprite(sprite, game_level)
	local cache = CCSpriteFrameCache:sharedSpriteFrameCache()
	local level_frame = cache:spriteFrameByName('duangong.png')
	if game_level then 
		cclog('set_level_sprite game_level is=> ' .. game_level)
		local picname = get_level_pic(game_level)
		level_frame  = cache:spriteFrameByName(picname)
	else
		cclog('set_level_sprite game_level is=> nil')
	end
	sprite:setDisplayFrame(level_frame)
	sprite:setVisible(true)
end

local wkd = {"星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"}
function get_weekday(wk_int) 
	for k,v in pairs(wkd) do
		cclog('kv wkd['..k..':'..v)
	end
	local weekday = wkd[tonumber(wk_int) + 1]
	cclog('weekday for ' .. tostring(wk_int) .. ' is ' .. weekday)
	return weekday
end

function set_rank_stroke(label, width)
	set_stroke(label, width or 2, GlobalSetting.rank_stroke)
end

function set_rank_string_with_stroke(label, str)
	label:setString(str)
	set_stroke(label, label.stroke_size or 2, label.stroke_color or GlobalSetting.rank_stroke)
end

function set_yellow_string_with_stroke(label, str)
	set_rank_string_with_stroke(label, str)
end

function set_string_with_stroke(label, str)
	label:setString(str)
	set_stroke(label, label.stroke_size, label.stroke_color)
end

function set_blue_stroke(label)
	set_stroke(label, 2, GlobalSetting.blue_stroke)
end

function set_light_blue_stroke(label)
	set_stroke(label, 2, GlobalSetting.light_blue_stroke)
end

function set_green_stroke(label)
	set_stroke(label, 2, GlobalSetting.green_stroke)
end

function set_red_stroke(label)
	set_stroke(label, 2, GlobalSetting.red_stroke)
end

function set_black_stroke(label)
	set_stroke(label, 2, GlobalSetting.black_stroke)
end

function remove_label_stroke(label)
	if label.stroke_sprite then 
		label.stroke_sprite:removeFromParentAndCleanup(true) 
		label.stroke_sprite = nil
	end
end

function hide_label_with_stroke(label)
	label:setVisible(false)
	remove_label_stroke(label)
end

function set_stroke(label, size, color)
	local stroke = create_stroke(label, size, color)
	if not label.stroke_sprite then
		label.stroke_sprite = CCSprite:createWithTexture(stroke:getSprite():getTexture())
		label:getParent():addChild(label.stroke_sprite, label:getZOrder() - 1)
		label.stroke_size = size
		label.stroke_color = color
	else
		label.stroke_sprite:setTexture(stroke:getSprite():getTexture())
		label.stroke_sprite:setTextureRect(stroke:getSprite():getTextureRect())
	end
	local x = label:getPositionX() + (2*label:getAnchorPoint().x - 1)*label.stroke_size
	local y = label:getPositionY() + (2*label:getAnchorPoint().y - 1)*label.stroke_size
	label.stroke_sprite:setPosition(ccp(x,y))
	label.stroke_sprite:setAnchorPoint(label:getAnchorPoint())
end

function create_stroke(label, size, color)
	if label:getZOrder() == 0 then
		label:getParent():reorderChild(label, 2)
	end
	local label_tx_width = label:getTexture():getContentSize().width
	local label_tx_height = label:getTexture():getContentSize().height
	local label_anchor_x = label:getAnchorPoint().x
	local label_anchor_y = label:getAnchorPoint().y

	local rt = CCRenderTexture:create(label_tx_width + size*2,
		label_tx_height + size*2)
	local originalPos = ccp(label:getPositionX(),label:getPositionY())
	local originalColor = label:getColor()
	local originalVisibility = label:isVisible()
	
	label:setColor(color)
	label:setVisible(true)
	
	local bottomLeft = ccp(label_tx_width*label_anchor_x + size, label_tx_height*label_anchor_y + size)
    local positionOffset = ccp(label_tx_width*label_anchor_x - label_tx_width/2, label_tx_height*label_anchor_y - label_tx_height/2)
    local position = ccpSub(originalPos, positionOffset)
    
    rt:begin()
    for i = 0,11 do
    	label:setFlipY(true)
        label:setPosition(ccp(bottomLeft.x + math.sin(0.01745329252*(i*30))*size, bottomLeft.y + math.cos(0.01745329252*(i*30))*size))
        label:visit()
	end
    rt:endToLua()

    label:setPosition(originalPos)
    label:setColor(originalColor)
    --label:setBlendFunc(originalBlend)
    label:setVisible(originalVisibility)
    label:setFlipY(false)
    rt:setPosition(position)

    return rt
end

function touchChild(node, arr)
	local node = tolua.cast(node, "CCNode")
	if (node:getTag() % 100) == 11 then
		table.insert(arr, node)
	end
	if node:getChildrenCount() > 0 then
		local children = node:getChildren()
		for index = 0, children:count()-1 do
			local child = children:objectAtIndex(index)
			touchChild(child, arr)
		end
	end
end

function getTouchChilds(node)
	local arr = {}
	touchChild(node, arr)
	return arr
end

function getMaxZOrder(node)
	local max = 0
	if node:getChildrenCount() > 0 then
		local children = node:getChildren()
		for index = 0, children:count()-1 do
			local child = children:objectAtIndex(index)
			if child.getZOrder then
				local child_order = child:getZOrder()
				if child_order > max then max = child_order end
			end
		end
	end
	return max
end

function getMaxZOrderVisibleChild(node)
	local max = 0
	local max_node = node
	if node:getChildrenCount() > 0 then
		local children = node:getChildren()
		for index = 0, children:count()-1 do
			local child = children:objectAtIndex(index)
			if child.getZOrder then
				local child_order = child:getZOrder()
				if child:isVisible() and child_order > max then max = child_order max_node = child end
			end
		end
	end
	return max_node
end

function getMaxZOrderVisible(node)
	return getMaxZOrderVisibleChild(node):getZOrder()
end

--node所在的scene的scene对象的rootNode
function getRootParent(node)
	while node:getParent() do
		node = node:getParent()
	end
	return node.rootNode
end

--node所在的scene是否有对话框正在显示
function hasDialogFloating(node)
	local max_visible_zorder_node = getMaxZOrderVisibleChild(getRootParent(node))
	local result = max_visible_zorder_node.is_dialog
	return result
end

--x,y点是否落在node的范围内
function cccn(node, x, y)
	return node:boundingBox():containsPoint(node:getParent():convertToNodeSpace(ccp(x, y)))
end

function runningscene()
	return	CCDirector:sharedDirector():getRunningScene()
end
