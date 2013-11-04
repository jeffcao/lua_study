resource_version = "2.0.0"

print("resource_version is ", resource_version)

local path = CCFileUtils:sharedFileUtils():getWritablePath()
local file1 = io.open(path.."/resources/Version.lua")

if file1 then
	print("file is in cache")
	file1:close()
	return
end

local file2 = io.open(path.."/resources/Version.lo")
if file2 then
	print("file is in cache")
	file2:close()
	return
end
local userDefault = CCUserDefault:sharedUserDefault()
local pkg_version = userDefault:getStringForKey("pkg_version_name")
print("file is in apk")
if pkg_version~= resource_version then
	CCDirector:sharedDirector():endToLua()
end