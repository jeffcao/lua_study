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
                   ../../Classes/MobClickCpp_lua.cpp \
                   ../../Classes/MobClickCppExtend_lua.cpp \
                   ../../Classes/md5_lua.cpp \
                   ../../Classes/Downloader.cpp \
                   ../../Classes/Downloader_lua.cpp \
					../../Classes/DDZJniHelper.cpp \
					../../Classes/DDZJniHelper_lua.cpp \

					                   
LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../Classes \
                  $(QUICK_COCOS2DX_ROOT)/lib/cocos2d-x \
					                    

#LOCAL_WHOLE_STATIC_LIBRARIES := cocos2dx_static cocosdenshion_static cocos_extension_static
#LOCAL_WHOLE_STATIC_LIBRARIES += cocos_lua_static

LOCAL_WHOLE_STATIC_LIBRARIES := quickcocos2dx

LOCAL_LDLIBS := libs/cocos2dx2_libMobClickCpp.a
			 

LOCAL_CPPFLAGS += -fexceptions
LOCAL_CPPFLAGS += -frtti

LOCAL_CFLAGS += -D__GXX_EXPERIMENTAL_CXX0X__ -std=c++11 -Wno-psabi -DCC_LUA_ENGINE_ENABLED=1 $(ANDROID_COCOS2D_BUILD_FLAGS)

            
include $(BUILD_SHARED_LIBRARY)

$(call import-module,lib/proj.android)
#$(call import-module,CocosDenshion/android) \
#$(call import-module,cocos2dx) \
#$(call import-module,scripting/lua/proj.android) \
#$(call import-module,extensions)
