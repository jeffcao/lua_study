LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := game_shared

LOCAL_MODULE_FILENAME := libgame

APP_ABI := armeabi

LWS_LIB_PATH := ../../Classes/libwebsockets/lib

QC_LIB_PATH := ../../Classes/quick_cocos2dx-lib

LOCAL_SRC_FILES := hellocpp/main.cpp \
                   ../../Classes/AppDelegate.cpp \
                   ../../Classes/Downloader.cpp \
 	                ../../Classes/WebsocketManager.cpp \
 	                ../../Classes/WebsocketManager_lua.cpp \
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

#					../../Classes/luasocket/wsocket.c \
					

#					$(LWS_LIB_PATH)/base64-decode.c \
					$(LWS_LIB_PATH)/client.c \
					$(LWS_LIB_PATH)/client-handshake.c \
					$(LWS_LIB_PATH)/client-parser.c \
					$(LWS_LIB_PATH)/handshake.c \
					$(LWS_LIB_PATH)/daemonize.c \
					$(LWS_LIB_PATH)/extension.c \
					$(LWS_LIB_PATH)/extension-deflate-frame.c \
					$(LWS_LIB_PATH)/extension-deflate-stream.c \
					$(LWS_LIB_PATH)/getifaddrs.c \
					$(LWS_LIB_PATH)/libwebsockets.c \
					$(LWS_LIB_PATH)/output.c \
					$(LWS_LIB_PATH)/parsers.c \
					
					
#					$(QC_LIB_PATH)/cocos2dx_extensions_luabinding/cocos2dx_extensions_luabinding.cpp \
					$(LWS_LIB_PATH)/parsers.c \
					$(LWS_LIB_PATH)/parsers.c \
					$(LWS_LIB_PATH)/parsers.c \

					                   
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../Classes \
					$(LOCAL_PATH)/../../Classes/cocos2dx-LuaProxy \
					$(LOCAL_PATH)/../../Classes/cjson \
					$(LOCAL_PATH)/../../Classes/luasocket \
					$(LOCAL_PATH)/../../Classes/libwebsockets/lib
					                    

LOCAL_WHOLE_STATIC_LIBRARIES := cocos2dx_static cocosdenshion_static cocos_extension_static
LOCAL_WHOLE_STATIC_LIBRARIES += cocos_lua_static


LOCAL_CFLAGS += -I$(LOCAL_PATH)/boost/include/boost-1_53
LOCAL_CFLAGS += -DLWS_BUILTIN_GETIFADDRS -DLWS_NO_SERVER


LOCAL_LDLIBS += -L$(LOCAL_PATH)/boost/lib/ \
				-lboost_thread-gcc-mt-1_53 \
				-lboost_system-gcc-mt-1_53 \
				-lboost_regex-gcc-mt-1_53				
				
			 

LOCAL_CPPFLAGS += -fexceptions
LOCAL_CPPFLAGS += -frtti

            
include $(BUILD_SHARED_LIBRARY)

$(call import-module,CocosDenshion/android) \
$(call import-module,cocos2dx) \
$(call import-module,scripting/lua/proj.android) \
$(call import-module,extensions)

