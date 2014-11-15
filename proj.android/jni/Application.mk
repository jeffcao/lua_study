APP_STL := gnustl_static
#APP_CPPFLAGS := -frtti -DCOCOS2D_DEBUG=1
APP_CPPFLAGS := -DCOCOS2D_DEBUG=1 -D__GXX_EXPERIMENTAL_CXX0X__ -std=c++11 -frtti -Wno-error=format-security -fsigned-char -Os $(CPPFLAGS)

APP_PLATFORM := android-8


ifeq ($(DDZ_DEBUG),1)
  APP_CPPFLAGS += -DDDZ_DEBUG=1
  APP_OPTIM := debug
else
  APP_OPTIM := release
endif
