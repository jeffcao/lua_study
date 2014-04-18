LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := game_shared

LOCAL_MODULE_FILENAME := libgame

APP_ABI := armeabi

LOCAL_SRC_FILES := hellocpp/main.cpp \
                   ../../Classes/AppDelegate.cpp \
                   ../../Classes/Marquee.cpp \
                   ../../Classes/Marquee_lua.cpp \
                   ../../Classes/CheckSign.cpp \
                   ../../Classes/CheckSign_lua.cpp \
                   ../../Classes/md5.cpp \
                   ../../Classes/md5_lua.cpp \
                   ../../Classes/Downloader.cpp \
                   ../../Classes/Downloader_lua.cpp \
 	                ../../Classes/DialogLayerConvertor.cpp \
 	                ../../Classes/DialogLayerConvertor_lua.cpp \
					../../Classes/cocos2dx-LuaProxy/tolua/CCBProxy.cpp \
					../../Classes/cocos2dx-LuaProxy/tolua/luaopen_LuaProxy.cpp \
					../../Classes/cocos2dx-LuaProxy/tolua/LuaEventHandler.cpp \
					../../Classes/cocos2dx-LuaProxy/tolua/LuaTableView.cpp \
					../../Classes/cocos2dx-LuaProxy/ui/CursorTextField.cpp \
					../../Classes/cjson/lua_extensions.c \
					../../Classes/cjson/fpconv.c \
					../../Classes/cjson/lua_cjson.c \
					../../Classes/cjson/strbuf.c \
					../../Classes/DDZJniHelper.cpp \
					../../Classes/DDZJniHelper_lua.cpp \
					../../Classes/luasocket/auxiliar.c \
					../../Classes/luasocket/buffer.c \
					../../Classes/luasocket/except.c \
					../../Classes/luasocket/inet.c \
					../../Classes/luasocket/io.c \
					../../Classes/luasocket/luasocket.c \
					../../Classes/luasocket/mime.c \
					../../Classes/luasocket/options.c \
					../../Classes/luasocket/select.c \
					../../Classes/luasocket/tcp.c \
					../../Classes/luasocket/timeout.c \
					../../Classes/luasocket/udp.c \
					../../Classes/luasocket/unix.c \
					../../Classes/luasocket/usocket.c \

					                   
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../Classes \
					$(LOCAL_PATH)/../../Classes/cocos2dx-LuaProxy \
					$(LOCAL_PATH)/../../Classes/cjson \
					$(LOCAL_PATH)/../../Classes/luasocket \
					                    

LOCAL_WHOLE_STATIC_LIBRARIES := cocos2dx_static cocosdenshion_static cocos_extension_static
LOCAL_WHOLE_STATIC_LIBRARIES += cocos_lua_static
			 

LOCAL_CPPFLAGS += -fexceptions
LOCAL_CPPFLAGS += -frtti

            
include $(BUILD_SHARED_LIBRARY)

$(call import-module,CocosDenshion/android) \
$(call import-module,cocos2dx) \
$(call import-module,scripting/lua/proj.android) \
$(call import-module,extensions)
