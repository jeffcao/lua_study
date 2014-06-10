/*
** Lua binding: MobClickCpp
** Generated automatically by tolua++-1.0.92 on Tue Jun 10 10:43:32 2014.
*/

/****************************************************************************
 Copyright (c) 2011 cocos2d-x.org

 http://www.cocos2d-x.org

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

extern "C" {
#include "tolua++.h"
#include "tolua_fix.h"
}
#include "MobClickCpp.h"

#include <map>
#include <string>
#include "cocos2d.h"
#include "CCLuaEngine.h"
#include "SimpleAudioEngine.h"
#include "cocos-ext.h"

using namespace cocos2d;
using namespace cocos2d::extension;
using namespace CocosDenshion;

/* Exported function */
TOLUA_API int  tolua_MobClickCpp_open (lua_State* tolua_S);


/* function to register type */
static void tolua_reg_types (lua_State* tolua_S)
{
 tolua_usertype(tolua_S,"MobClickCpp");
}

/* method: setAppVersion of class  MobClickCpp */
#ifndef TOLUA_DISABLE_tolua_MobClickCpp_MobClickCpp_setAppVersion00
static int tolua_MobClickCpp_MobClickCpp_setAppVersion00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MobClickCpp",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* appVersion = ((const char*)  tolua_tostring(tolua_S,2,0));
  {
   MobClickCpp::setAppVersion(appVersion);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setAppVersion'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setCrashReportEnabled of class  MobClickCpp */
#ifndef TOLUA_DISABLE_tolua_MobClickCpp_MobClickCpp_setCrashReportEnabled00
static int tolua_MobClickCpp_MobClickCpp_setCrashReportEnabled00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MobClickCpp",0,&tolua_err) ||
     !tolua_isboolean(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  bool value = ((bool)  tolua_toboolean(tolua_S,2,0));
  {
   MobClickCpp::setCrashReportEnabled(value);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setCrashReportEnabled'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setLogEnabled of class  MobClickCpp */
#ifndef TOLUA_DISABLE_tolua_MobClickCpp_MobClickCpp_setLogEnabled00
static int tolua_MobClickCpp_MobClickCpp_setLogEnabled00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MobClickCpp",0,&tolua_err) ||
     !tolua_isboolean(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  bool value = ((bool)  tolua_toboolean(tolua_S,2,0));
  {
   MobClickCpp::setLogEnabled(value);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setLogEnabled'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: initJniForCocos2dx2 of class  MobClickCpp */
#ifndef TOLUA_DISABLE_tolua_MobClickCpp_MobClickCpp_initJniForCocos2dx200
static int tolua_MobClickCpp_MobClickCpp_initJniForCocos2dx200(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MobClickCpp",0,&tolua_err) ||
     !tolua_isuserdata(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  void* vm = ((void*)  tolua_touserdata(tolua_S,2,0));
  const char* activityName = ((const char*)  tolua_tostring(tolua_S,3,0));
  {
   MobClickCpp::initJniForCocos2dx2(vm,activityName);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'initJniForCocos2dx2'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: startWithAppkey of class  MobClickCpp */
#ifndef TOLUA_DISABLE_tolua_MobClickCpp_MobClickCpp_startWithAppkey00
static int tolua_MobClickCpp_MobClickCpp_startWithAppkey00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MobClickCpp",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,1,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* appKey = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* channelId = ((const char*)  tolua_tostring(tolua_S,3,NULL));
  {
   MobClickCpp::startWithAppkey(appKey,channelId);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'startWithAppkey'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: applicationDidEnterBackground of class  MobClickCpp */
#ifndef TOLUA_DISABLE_tolua_MobClickCpp_MobClickCpp_applicationDidEnterBackground00
static int tolua_MobClickCpp_MobClickCpp_applicationDidEnterBackground00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MobClickCpp",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   MobClickCpp::applicationDidEnterBackground();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'applicationDidEnterBackground'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: applicationWillEnterForeground of class  MobClickCpp */
#ifndef TOLUA_DISABLE_tolua_MobClickCpp_MobClickCpp_applicationWillEnterForeground00
static int tolua_MobClickCpp_MobClickCpp_applicationWillEnterForeground00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MobClickCpp",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   MobClickCpp::applicationWillEnterForeground();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'applicationWillEnterForeground'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: end of class  MobClickCpp */
#ifndef TOLUA_DISABLE_tolua_MobClickCpp_MobClickCpp_end00
static int tolua_MobClickCpp_MobClickCpp_end00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MobClickCpp",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   MobClickCpp::end();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'end'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: beginEvent of class  MobClickCpp */
#ifndef TOLUA_DISABLE_tolua_MobClickCpp_MobClickCpp_beginEvent00
static int tolua_MobClickCpp_MobClickCpp_beginEvent00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MobClickCpp",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* eventId = ((const char*)  tolua_tostring(tolua_S,2,0));
  {
   MobClickCpp::beginEvent(eventId);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'beginEvent'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: endEvent of class  MobClickCpp */
#ifndef TOLUA_DISABLE_tolua_MobClickCpp_MobClickCpp_endEvent00
static int tolua_MobClickCpp_MobClickCpp_endEvent00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MobClickCpp",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* eventId = ((const char*)  tolua_tostring(tolua_S,2,0));
  {
   MobClickCpp::endEvent(eventId);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'endEvent'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: beginEventWithLabel of class  MobClickCpp */
#ifndef TOLUA_DISABLE_tolua_MobClickCpp_MobClickCpp_beginEventWithLabel00
static int tolua_MobClickCpp_MobClickCpp_beginEventWithLabel00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MobClickCpp",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* eventId = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* label = ((const char*)  tolua_tostring(tolua_S,3,0));
  {
   MobClickCpp::beginEventWithLabel(eventId,label);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'beginEventWithLabel'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: endEventWithLabel of class  MobClickCpp */
#ifndef TOLUA_DISABLE_tolua_MobClickCpp_MobClickCpp_endEventWithLabel00
static int tolua_MobClickCpp_MobClickCpp_endEventWithLabel00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MobClickCpp",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* eventId = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* label = ((const char*)  tolua_tostring(tolua_S,3,0));
  {
   MobClickCpp::endEventWithLabel(eventId,label);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'endEventWithLabel'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: endEventWithAttributes of class  MobClickCpp */
#ifndef TOLUA_DISABLE_tolua_MobClickCpp_MobClickCpp_endEventWithAttributes00
static int tolua_MobClickCpp_MobClickCpp_endEventWithAttributes00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MobClickCpp",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* eventId = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* primarykey = ((const char*)  tolua_tostring(tolua_S,3,0));
  {
   MobClickCpp::endEventWithAttributes(eventId,primarykey);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'endEventWithAttributes'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: beginLogPageView of class  MobClickCpp */
#ifndef TOLUA_DISABLE_tolua_MobClickCpp_MobClickCpp_beginLogPageView00
static int tolua_MobClickCpp_MobClickCpp_beginLogPageView00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MobClickCpp",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* pageName = ((const char*)  tolua_tostring(tolua_S,2,0));
  {
   MobClickCpp::beginLogPageView(pageName);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'beginLogPageView'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: endLogPageView of class  MobClickCpp */
#ifndef TOLUA_DISABLE_tolua_MobClickCpp_MobClickCpp_endLogPageView00
static int tolua_MobClickCpp_MobClickCpp_endLogPageView00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MobClickCpp",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* pageName = ((const char*)  tolua_tostring(tolua_S,2,0));
  {
   MobClickCpp::endLogPageView(pageName);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'endLogPageView'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setUpdateOnlyWifi of class  MobClickCpp */
#ifndef TOLUA_DISABLE_tolua_MobClickCpp_MobClickCpp_setUpdateOnlyWifi00
static int tolua_MobClickCpp_MobClickCpp_setUpdateOnlyWifi00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MobClickCpp",0,&tolua_err) ||
     !tolua_isboolean(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  bool updateOnlyWifi = ((bool)  tolua_toboolean(tolua_S,2,0));
  {
   MobClickCpp::setUpdateOnlyWifi(updateOnlyWifi);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setUpdateOnlyWifi'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: updateOnlineConfig of class  MobClickCpp */
#ifndef TOLUA_DISABLE_tolua_MobClickCpp_MobClickCpp_updateOnlineConfig00
static int tolua_MobClickCpp_MobClickCpp_updateOnlineConfig00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MobClickCpp",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   MobClickCpp::updateOnlineConfig();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'updateOnlineConfig'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: getConfigParams of class  MobClickCpp */
#ifndef TOLUA_DISABLE_tolua_MobClickCpp_MobClickCpp_getConfigParams00
static int tolua_MobClickCpp_MobClickCpp_getConfigParams00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MobClickCpp",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* key = ((const char*)  tolua_tostring(tolua_S,2,0));
  {
   string tolua_ret = (string)  MobClickCpp::getConfigParams(key);
   tolua_pushcppstring(tolua_S,(const char*)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'getConfigParams'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: setUserLevel of class  MobClickCpp */
#ifndef TOLUA_DISABLE_tolua_MobClickCpp_MobClickCpp_setUserLevel00
static int tolua_MobClickCpp_MobClickCpp_setUserLevel00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MobClickCpp",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* level = ((const char*)  tolua_tostring(tolua_S,2,0));
  {
   MobClickCpp::setUserLevel(level);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'setUserLevel'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: startLevel of class  MobClickCpp */
#ifndef TOLUA_DISABLE_tolua_MobClickCpp_MobClickCpp_startLevel00
static int tolua_MobClickCpp_MobClickCpp_startLevel00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MobClickCpp",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* level = ((const char*)  tolua_tostring(tolua_S,2,0));
  {
   MobClickCpp::startLevel(level);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'startLevel'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: finishLevel of class  MobClickCpp */
#ifndef TOLUA_DISABLE_tolua_MobClickCpp_MobClickCpp_finishLevel00
static int tolua_MobClickCpp_MobClickCpp_finishLevel00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MobClickCpp",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* level = ((const char*)  tolua_tostring(tolua_S,2,0));
  {
   MobClickCpp::finishLevel(level);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'finishLevel'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: failLevel of class  MobClickCpp */
#ifndef TOLUA_DISABLE_tolua_MobClickCpp_MobClickCpp_failLevel00
static int tolua_MobClickCpp_MobClickCpp_failLevel00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MobClickCpp",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* level = ((const char*)  tolua_tostring(tolua_S,2,0));
  {
   MobClickCpp::failLevel(level);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'failLevel'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: pay of class  MobClickCpp */
#ifndef TOLUA_DISABLE_tolua_MobClickCpp_MobClickCpp_pay00
static int tolua_MobClickCpp_MobClickCpp_pay00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MobClickCpp",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  double cash = ((double)  tolua_tonumber(tolua_S,2,0));
  int source = ((int)  tolua_tonumber(tolua_S,3,0));
  double coin = ((double)  tolua_tonumber(tolua_S,4,0));
  {
   MobClickCpp::pay(cash,source,coin);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'pay'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: pay of class  MobClickCpp */
#ifndef TOLUA_DISABLE_tolua_MobClickCpp_MobClickCpp_pay01
static int tolua_MobClickCpp_MobClickCpp_pay01(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MobClickCpp",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isstring(tolua_S,4,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,5,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,6,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,7,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  double cash = ((double)  tolua_tonumber(tolua_S,2,0));
  int source = ((int)  tolua_tonumber(tolua_S,3,0));
  const char* item = ((const char*)  tolua_tostring(tolua_S,4,0));
  int amount = ((int)  tolua_tonumber(tolua_S,5,0));
  double price = ((double)  tolua_tonumber(tolua_S,6,0));
  {
   MobClickCpp::pay(cash,source,item,amount,price);
  }
 }
 return 0;
tolua_lerror:
 return tolua_MobClickCpp_MobClickCpp_pay00(tolua_S);
}
#endif //#ifndef TOLUA_DISABLE

/* method: buy of class  MobClickCpp */
#ifndef TOLUA_DISABLE_tolua_MobClickCpp_MobClickCpp_buy00
static int tolua_MobClickCpp_MobClickCpp_buy00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MobClickCpp",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* item = ((const char*)  tolua_tostring(tolua_S,2,0));
  int amount = ((int)  tolua_tonumber(tolua_S,3,0));
  double price = ((double)  tolua_tonumber(tolua_S,4,0));
  {
   MobClickCpp::buy(item,amount,price);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'buy'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: use of class  MobClickCpp */
#ifndef TOLUA_DISABLE_tolua_MobClickCpp_MobClickCpp_use00
static int tolua_MobClickCpp_MobClickCpp_use00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MobClickCpp",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* item = ((const char*)  tolua_tostring(tolua_S,2,0));
  int amount = ((int)  tolua_tonumber(tolua_S,3,0));
  double price = ((double)  tolua_tonumber(tolua_S,4,0));
  {
   MobClickCpp::use(item,amount,price);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'use'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: bonus of class  MobClickCpp */
#ifndef TOLUA_DISABLE_tolua_MobClickCpp_MobClickCpp_bonus00
static int tolua_MobClickCpp_MobClickCpp_bonus00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MobClickCpp",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  double coin = ((double)  tolua_tonumber(tolua_S,2,0));
  int source = ((int)  tolua_tonumber(tolua_S,3,0));
  {
   MobClickCpp::bonus(coin,source);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'bonus'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: bonus of class  MobClickCpp */
#ifndef TOLUA_DISABLE_tolua_MobClickCpp_MobClickCpp_bonus01
static int tolua_MobClickCpp_MobClickCpp_bonus01(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MobClickCpp",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,5,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,6,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  const char* item = ((const char*)  tolua_tostring(tolua_S,2,0));
  int amount = ((int)  tolua_tonumber(tolua_S,3,0));
  double price = ((double)  tolua_tonumber(tolua_S,4,0));
  int source = ((int)  tolua_tonumber(tolua_S,5,0));
  {
   MobClickCpp::bonus(item,amount,price,source);
  }
 }
 return 0;
tolua_lerror:
 return tolua_MobClickCpp_MobClickCpp_bonus00(tolua_S);
}
#endif //#ifndef TOLUA_DISABLE

/* method: beginScene of class  MobClickCpp */
#ifndef TOLUA_DISABLE_tolua_MobClickCpp_MobClickCpp_beginScene00
static int tolua_MobClickCpp_MobClickCpp_beginScene00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MobClickCpp",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* sceneName = ((const char*)  tolua_tostring(tolua_S,2,0));
  {
   MobClickCpp::beginScene(sceneName);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'beginScene'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: endScene of class  MobClickCpp */
#ifndef TOLUA_DISABLE_tolua_MobClickCpp_MobClickCpp_endScene00
static int tolua_MobClickCpp_MobClickCpp_endScene00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MobClickCpp",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* sceneName = ((const char*)  tolua_tostring(tolua_S,2,0));
  {
   MobClickCpp::endScene(sceneName);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'endScene'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* Open function */
TOLUA_API int tolua_MobClickCpp_open (lua_State* tolua_S)
{
 tolua_open(tolua_S);
 tolua_reg_types(tolua_S);
 tolua_module(tolua_S,NULL,0);
 tolua_beginmodule(tolua_S,NULL);
  tolua_cclass(tolua_S,"MobClickCpp","MobClickCpp","",NULL);
  tolua_beginmodule(tolua_S,"MobClickCpp");
   tolua_function(tolua_S,"setAppVersion",tolua_MobClickCpp_MobClickCpp_setAppVersion00);
   tolua_function(tolua_S,"setCrashReportEnabled",tolua_MobClickCpp_MobClickCpp_setCrashReportEnabled00);
   tolua_function(tolua_S,"setLogEnabled",tolua_MobClickCpp_MobClickCpp_setLogEnabled00);
   tolua_function(tolua_S,"initJniForCocos2dx2",tolua_MobClickCpp_MobClickCpp_initJniForCocos2dx200);
   tolua_function(tolua_S,"startWithAppkey",tolua_MobClickCpp_MobClickCpp_startWithAppkey00);
   tolua_function(tolua_S,"applicationDidEnterBackground",tolua_MobClickCpp_MobClickCpp_applicationDidEnterBackground00);
   tolua_function(tolua_S,"applicationWillEnterForeground",tolua_MobClickCpp_MobClickCpp_applicationWillEnterForeground00);
   tolua_function(tolua_S,"end",tolua_MobClickCpp_MobClickCpp_end00);
   tolua_function(tolua_S,"beginEvent",tolua_MobClickCpp_MobClickCpp_beginEvent00);
   tolua_function(tolua_S,"endEvent",tolua_MobClickCpp_MobClickCpp_endEvent00);
   tolua_function(tolua_S,"beginEventWithLabel",tolua_MobClickCpp_MobClickCpp_beginEventWithLabel00);
   tolua_function(tolua_S,"endEventWithLabel",tolua_MobClickCpp_MobClickCpp_endEventWithLabel00);
   tolua_function(tolua_S,"endEventWithAttributes",tolua_MobClickCpp_MobClickCpp_endEventWithAttributes00);
   tolua_function(tolua_S,"beginLogPageView",tolua_MobClickCpp_MobClickCpp_beginLogPageView00);
   tolua_function(tolua_S,"endLogPageView",tolua_MobClickCpp_MobClickCpp_endLogPageView00);
   tolua_function(tolua_S,"setUpdateOnlyWifi",tolua_MobClickCpp_MobClickCpp_setUpdateOnlyWifi00);
   tolua_function(tolua_S,"updateOnlineConfig",tolua_MobClickCpp_MobClickCpp_updateOnlineConfig00);
   tolua_function(tolua_S,"getConfigParams",tolua_MobClickCpp_MobClickCpp_getConfigParams00);
   tolua_function(tolua_S,"setUserLevel",tolua_MobClickCpp_MobClickCpp_setUserLevel00);
   tolua_function(tolua_S,"startLevel",tolua_MobClickCpp_MobClickCpp_startLevel00);
   tolua_function(tolua_S,"finishLevel",tolua_MobClickCpp_MobClickCpp_finishLevel00);
   tolua_function(tolua_S,"failLevel",tolua_MobClickCpp_MobClickCpp_failLevel00);
   tolua_function(tolua_S,"pay",tolua_MobClickCpp_MobClickCpp_pay00);
   tolua_function(tolua_S,"pay",tolua_MobClickCpp_MobClickCpp_pay01);
   tolua_function(tolua_S,"buy",tolua_MobClickCpp_MobClickCpp_buy00);
   tolua_function(tolua_S,"use",tolua_MobClickCpp_MobClickCpp_use00);
   tolua_function(tolua_S,"bonus",tolua_MobClickCpp_MobClickCpp_bonus00);
   tolua_function(tolua_S,"bonus",tolua_MobClickCpp_MobClickCpp_bonus01);
   tolua_function(tolua_S,"beginScene",tolua_MobClickCpp_MobClickCpp_beginScene00);
   tolua_function(tolua_S,"endScene",tolua_MobClickCpp_MobClickCpp_endScene00);
  tolua_endmodule(tolua_S);
 tolua_endmodule(tolua_S);
 return 1;
}


#if defined(LUA_VERSION_NUM) && LUA_VERSION_NUM >= 501
 TOLUA_API int luaopen_MobClickCpp (lua_State* tolua_S) {
 return tolua_MobClickCpp_open(tolua_S);
};
#endif

