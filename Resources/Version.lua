resource_version = "2.2.1"

print("resource_version is ", resource_version)

local userDefault = CCUserDefault:sharedUserDefault()
local apk_version = userDefault:getStringForKey("pkg_version_name")

local path = CCFileUtils:sharedFileUtils():getWritablePath()

local function getBigVersion(version)
	local version_number = string.gsub(version, "%.%d+$", "")
	return tonumber(version_number)
end

if getBigVersion(apk_version) > getBigVersion(resource_version) then
	cclog("apk version %s, resource version %s", apk_version, resource_version)
	cclog("apk update, resources be invalidate, remove")
	local jni_helper = DDZJniHelper:create()
	jni_helper:messageJava("on_delete_file_"..path.."resources")
	local file_utils = CCFileUtils:sharedFileUtils()
	file_utils:purgeCachedEntries()
	package.loaded["Version"] = nil
	require "Version"
	cclog("re-require version as resources been invalidate")
else
	cclog("apk version %s is not greater than resource version %s", apk_version, resource_version)
end


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
