/*
** Lua binding: CCEditBoxBridge
** Generated automatically by tolua++-1.0.93 on Thu May 23 15:36:01 2013.
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

#include "CCEditBoxBridge.h"
/* Exported function */
TOLUA_API int  tolua_CCEditBoxBridge_open (lua_State* tolua_S);


/* function to register type */
static void tolua_reg_types (lua_State* tolua_S)
{
 tolua_usertype(tolua_S,"CCEditBoxBridge");
 tolua_usertype(tolua_S,"CCNode");
 tolua_usertype(tolua_S,"cocos2d::CCObject");
}

/* method: create of class  CCEditBoxBridge */
#ifndef TOLUA_DISABLE_tolua_CCEditBoxBridge_CCEditBoxBridge_create00
static int tolua_CCEditBoxBridge_CCEditBoxBridge_create00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"CCEditBoxBridge",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,5,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,6,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  const char* plist_name = ((const char*)  tolua_tostring(tolua_S,2,0));
  const char* normal9scale = ((const char*)  tolua_tostring(tolua_S,3,0));
  int height = ((int)  tolua_tonumber(tolua_S,4,0));
  int width = ((int)  tolua_tonumber(tolua_S,5,0));
  {
   CCEditBoxBridge* tolua_ret = (CCEditBoxBridge*)  CCEditBoxBridge::create(plist_name,normal9scale,height,width);
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"CCEditBoxBridge");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'create'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: addTo of class  CCEditBoxBridge */
#ifndef TOLUA_DISABLE_tolua_CCEditBoxBridge_CCEditBoxBridge_addTo00
static int tolua_CCEditBoxBridge_CCEditBoxBridge_addTo00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"CCEditBoxBridge",0,&tolua_err) ||
     !tolua_isusertype(tolua_S,2,"CCNode",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,3,0,&tolua_err) ||
     !tolua_isnumber(tolua_S,4,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,5,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCEditBoxBridge* self = (CCEditBoxBridge*)  tolua_tousertype(tolua_S,1,0);
  CCNode* node = ((CCNode*)  tolua_tousertype(tolua_S,2,0));
  int x = ((int)  tolua_tonumber(tolua_S,3,0));
  int y = ((int)  tolua_tonumber(tolua_S,4,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'addTo'", NULL);
#endif
  {
   self->addTo(node,x,y);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'addTo'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* Open function */
TOLUA_API int tolua_CCEditBoxBridge_open (lua_State* tolua_S)
{
 tolua_open(tolua_S);
 tolua_reg_types(tolua_S);
 tolua_module(tolua_S,NULL,0);
 tolua_beginmodule(tolua_S,NULL);
  tolua_cclass(tolua_S,"CCEditBoxBridge","CCEditBoxBridge","cocos2d::CCObject",NULL);
  tolua_beginmodule(tolua_S,"CCEditBoxBridge");
   tolua_function(tolua_S,"create",tolua_CCEditBoxBridge_CCEditBoxBridge_create00);
   tolua_function(tolua_S,"addTo",tolua_CCEditBoxBridge_CCEditBoxBridge_addTo00);
  tolua_endmodule(tolua_S);
 tolua_endmodule(tolua_S);
 return 1;
}


#if defined(LUA_VERSION_NUM) && LUA_VERSION_NUM >= 501
 TOLUA_API int luaopen_CCEditBoxBridge (lua_State* tolua_S) {
 return tolua_CCEditBoxBridge_open(tolua_S);
};
#endif

