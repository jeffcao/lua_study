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
TOLUA_API int  tolua_MobClickCpp_extend (lua_State* tolua_S);


/* function to register type */
static void tolua_reg_types (lua_State* tolua_S)
{
 tolua_usertype(tolua_S,"MobClickCpp");
}

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

//beginEventWithAttributes
#ifndef TOLUA_DISABLE_tolua_MobClickCpp_MobClickCpp_beginEventWithAttributes
static int tolua_MobClickCpp_MobClickCpp_beginEventWithAttributes(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MobClickCpp",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) || //eventId
     !tolua_isstring(tolua_S,3,0,&tolua_err) || //primaryKey
     !tolua_isuserdata(tolua_S,4,0,&tolua_err) || //attributes
     !tolua_isnoobj(tolua_S,6,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  const char* eventId = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* primaryKey = ((const char*)  tolua_tostring(tolua_S,3,0));

  CCDictionary *attributes = (CCDictionary *)tolua_touserdata(tolua_S, 4, NULL);
  eventDict e;

  CCDictElement* pElement;
  CCDICT_FOREACH(attributes, pElement)
  {
     const char*key = pElement->getStrKey();
     const char* value = ((CCString*)pElement->getObject())->getCString();
     CCLog("MobClickCpp:beginEventWithAttributes key-value:(%s->%s)", key, value);
     e.insert(pair<std::string, std::string>(key, value));
  }

  {
   CCLog("MobClickCpp::beginEventWithAttributes(%s, %s, attributes)", eventId, primaryKey);
   MobClickCpp::beginEventWithAttributes(eventId, primaryKey, &e);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'event'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

#ifndef TOLUA_DISABLE_tolua_MobClickCpp_MobClickCpp_setUserInfo
static int tolua_MobClickCpp_MobClickCpp_setUserInfo(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MobClickCpp",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) || //userId
     !tolua_isnumber(tolua_S,3,0,&tolua_err) || //sex
     !tolua_isnumber(tolua_S,4,0,&tolua_err) || //age
     !tolua_isstring(tolua_S,5,1,&tolua_err) || //platform
     !tolua_isnoobj(tolua_S,6,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  const char* userId = ((const char*)  tolua_tostring(tolua_S,2,0));
  int sex =((int) tolua_tonumber(tolua_S,3,0));
  int age =((int) tolua_tonumber(tolua_S,4,0));
  const char* platform = ((const char*)  tolua_tostring(tolua_S,5,"android"));

  {
   CCLog("MobClickCpp::setUserInfo(%s, %d, %d, %s)", userId, sex, age, platform);
   MobClickCpp::setUserInfo(userId, static_cast<MobClickCpp::Sex>(sex), age, platform);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'event'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE



/* method: bonus of class  MobClickCpp */
#ifndef TOLUA_DISABLE_tolua_MobClickCpp_MobClickCpp_event00
static int tolua_MobClickCpp_MobClickCpp_event00(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MobClickCpp",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) || //eventId
     !tolua_isuserdata(tolua_S,3,0,&tolua_err) || //attributes
     !tolua_isnumber(tolua_S,4,1,&tolua_err) || //counter
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  const char* eventId = ((const char*)  tolua_tostring(tolua_S,2,0));
  CCDictionary *attributes = (CCDictionary *)tolua_touserdata(tolua_S, 3, NULL);
  int counter = ((int) tolua_tonumber(tolua_S,4,0));
  eventDict e;

  CCDictElement* pElement;
  CCDICT_FOREACH(attributes, pElement)
  {
     const char*key = pElement->getStrKey();
     const char* value = ((CCString*)pElement->getObject())->getCString();
     CCLog("MobClickCpp:event key-value:(%s->%s)", key, value);
     e.insert(pair<std::string, std::string>(key, value));
   }

  {
   CCLog("MobClickCpp::event(%s, dictionary, %d)", eventId, counter);
   MobClickCpp::event(eventId, &e, counter);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'event'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: bonus of class  MobClickCpp */
#ifndef TOLUA_DISABLE_tolua_MobClickCpp_MobClickCpp_event01
static int tolua_MobClickCpp_MobClickCpp_event01(lua_State* tolua_S)
{
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"MobClickCpp",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) || //eventId
     !tolua_isstring(tolua_S,3,1,&tolua_err) || //label
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
 {
  const char* eventId = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* label = ((const char*) tolua_tostring(tolua_S,3,NULL));
  {
   CCLog("MobClickCpp::event(%s, %s)", eventId, label);
   MobClickCpp::event(eventId,label);
  }
 }
 return 0;
tolua_lerror:
 return tolua_MobClickCpp_MobClickCpp_event00(tolua_S);
}
#endif //#ifndef TOLUA_DISABLE

/* Open function */
TOLUA_API int tolua_MobClickCpp_extend (lua_State* tolua_S)
{
 tolua_open(tolua_S);
 tolua_reg_types(tolua_S);
 tolua_module(tolua_S,NULL,0);
 tolua_beginmodule(tolua_S,NULL);
  tolua_cclass(tolua_S,"MobClickCpp","MobClickCpp","",NULL);
  tolua_beginmodule(tolua_S,"MobClickCpp");
   tolua_function(tolua_S,"event",tolua_MobClickCpp_MobClickCpp_event00);
   tolua_function(tolua_S,"event",tolua_MobClickCpp_MobClickCpp_event01);
   tolua_function(tolua_S,"setUserInfo",tolua_MobClickCpp_MobClickCpp_setUserInfo);
   tolua_function(tolua_S,"beginEventWithAttributes",tolua_MobClickCpp_MobClickCpp_beginEventWithAttributes);
   tolua_function(tolua_S,"endToLua",tolua_MobClickCpp_MobClickCpp_end00);
  tolua_endmodule(tolua_S);
 tolua_endmodule(tolua_S);
 return 1;
}


#if defined(LUA_VERSION_NUM) && LUA_VERSION_NUM >= 501
 TOLUA_API int luaopen_MobClickCppExtend (lua_State* tolua_S) {
 return tolua_MobClickCpp_extend(tolua_S);
};
#endif

