/*
** Lua binding: WebsocketManager
** Generated automatically by tolua++-1.0.92 on Mon May  6 11:42:13 2013.
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

#include "WebsocketManager.h"

/* Exported function */
TOLUA_API int  tolua_WebsocketManager_open (lua_State* tolua_S);


/* function to register type */
static void tolua_reg_types (lua_State* tolua_S)
{
 
 tolua_usertype(tolua_S,"cocos2d::CCObject");
 tolua_usertype(tolua_S,"WebsocketManager");
}

/* method: sharedWebsocketManager of class  WebsocketManager */
#ifndef TOLUA_DISABLE_tolua_WebsocketManager_WebsocketManager_sharedWebsocketManager00
static int tolua_WebsocketManager_WebsocketManager_sharedWebsocketManager00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"WebsocketManager",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  {
   WebsocketManager* tolua_ret = (WebsocketManager*)  WebsocketManager::sharedWebsocketManager();
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"WebsocketManager");
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'sharedWebsocketManager'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: connect of class  WebsocketManager */
#ifndef TOLUA_DISABLE_tolua_WebsocketManager_WebsocketManager_connect00
static int tolua_WebsocketManager_WebsocketManager_connect00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"WebsocketManager",0,&tolua_err) ||
     !tolua_isstring(tolua_S,2,0,&tolua_err) ||
     (tolua_isvaluenil(tolua_S,3,&tolua_err) || !toluafix_isfunction(tolua_S,3,"LUA_FUNCTION",0,&tolua_err)) ||
     (tolua_isvaluenil(tolua_S,4,&tolua_err) || !toluafix_isfunction(tolua_S,4,"LUA_FUNCTION",0,&tolua_err)) ||
     (tolua_isvaluenil(tolua_S,5,&tolua_err) || !toluafix_isfunction(tolua_S,5,"LUA_FUNCTION",0,&tolua_err)) ||
     (tolua_isvaluenil(tolua_S,6,&tolua_err) || !toluafix_isfunction(tolua_S,6,"LUA_FUNCTION",0,&tolua_err)) ||
     !tolua_isnoobj(tolua_S,7,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  WebsocketManager* self = (WebsocketManager*)  tolua_tousertype(tolua_S,1,0);
  const char* uri = ((const char*)  tolua_tostring(tolua_S,2,0));
  LUA_FUNCTION on_open_handler = (  toluafix_ref_function(tolua_S,3,0));
  LUA_FUNCTION on_close_handler = (  toluafix_ref_function(tolua_S,4,0));
  LUA_FUNCTION on_message_handler = (  toluafix_ref_function(tolua_S,5,0));
  LUA_FUNCTION on_error_handler = (  toluafix_ref_function(tolua_S,6,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'connect'", NULL);
#endif
  {
    int tolua_ret = (  int)  self->connect(uri,on_open_handler,on_close_handler,on_message_handler,on_error_handler);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'connect'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: close of class  WebsocketManager */
#ifndef TOLUA_DISABLE_tolua_WebsocketManager_WebsocketManager_close00
static int tolua_WebsocketManager_WebsocketManager_close00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"WebsocketManager",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  WebsocketManager* self = (WebsocketManager*)  tolua_tousertype(tolua_S,1,0);
   int websocket = ((  int)  tolua_tonumber(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'close'", NULL);
#endif
  {
   self->close(websocket);
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'close'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: send of class  WebsocketManager */
#ifndef TOLUA_DISABLE_tolua_WebsocketManager_WebsocketManager_send00
static int tolua_WebsocketManager_WebsocketManager_send00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"WebsocketManager",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isstring(tolua_S,3,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,4,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  WebsocketManager* self = (WebsocketManager*)  tolua_tousertype(tolua_S,1,0);
   int websocket = ((  int)  tolua_tonumber(tolua_S,2,0));
  const char* message = ((const char*)  tolua_tostring(tolua_S,3,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'send'", NULL);
#endif
  {
   bool tolua_ret = (bool)  self->send(websocket,message);
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'send'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: close_all_websockets of class  WebsocketManager */
#ifndef TOLUA_DISABLE_tolua_WebsocketManager_WebsocketManager_close_all_websockets00
static int tolua_WebsocketManager_WebsocketManager_close_all_websockets00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"WebsocketManager",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  WebsocketManager* self = (WebsocketManager*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'close_all_websockets'", NULL);
#endif
  {
   self->close_all_websockets();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'close_all_websockets'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: get_websocket_state of class  WebsocketManager */
#ifndef TOLUA_DISABLE_tolua_WebsocketManager_WebsocketManager_get_websocket_state00
static int tolua_WebsocketManager_WebsocketManager_get_websocket_state00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"WebsocketManager",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  WebsocketManager* self = (WebsocketManager*)  tolua_tousertype(tolua_S,1,0);
   int websocket = ((  int)  tolua_tonumber(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'get_websocket_state'", NULL);
#endif
  {
   WebsocketState tolua_ret = (WebsocketState)  self->get_websocket_state(websocket);
   tolua_pushnumber(tolua_S,(lua_Number)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'get_websocket_state'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: is_connected of class  WebsocketManager */
#ifndef TOLUA_DISABLE_tolua_WebsocketManager_WebsocketManager_is_connected00
static int tolua_WebsocketManager_WebsocketManager_is_connected00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"WebsocketManager",0,&tolua_err) ||
     !tolua_isnumber(tolua_S,2,0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  WebsocketManager* self = (WebsocketManager*)  tolua_tousertype(tolua_S,1,0);
   int websocket = ((  int)  tolua_tonumber(tolua_S,2,0));
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'is_connected'", NULL);
#endif
  {
   bool tolua_ret = (bool)  self->is_connected(websocket);
   tolua_pushboolean(tolua_S,(bool)tolua_ret);
  }
 }
 return 1;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'is_connected'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* Open function */
TOLUA_API int tolua_WebsocketManager_open (lua_State* tolua_S)
{
 tolua_open(tolua_S);
 tolua_reg_types(tolua_S);
 tolua_module(tolua_S,NULL,0);
 tolua_beginmodule(tolua_S,NULL);
  tolua_constant(tolua_S,"wsInvalid",wsInvalid);
  tolua_constant(tolua_S,"wsConnecting",wsConnecting);
  tolua_constant(tolua_S,"wsConnected",wsConnected);
  tolua_constant(tolua_S,"wsClosed",wsClosed);
  tolua_constant(tolua_S,"wsError",wsError);
  tolua_cclass(tolua_S,"WebsocketManager","WebsocketManager","cocos2d::CCObject",NULL);
  tolua_beginmodule(tolua_S,"WebsocketManager");
   tolua_function(tolua_S,"sharedWebsocketManager",tolua_WebsocketManager_WebsocketManager_sharedWebsocketManager00);
   tolua_function(tolua_S,"connect",tolua_WebsocketManager_WebsocketManager_connect00);
   tolua_function(tolua_S,"close",tolua_WebsocketManager_WebsocketManager_close00);
   tolua_function(tolua_S,"send",tolua_WebsocketManager_WebsocketManager_send00);
   tolua_function(tolua_S,"close_all_websockets",tolua_WebsocketManager_WebsocketManager_close_all_websockets00);
   tolua_function(tolua_S,"get_websocket_state",tolua_WebsocketManager_WebsocketManager_get_websocket_state00);
   tolua_function(tolua_S,"is_connected",tolua_WebsocketManager_WebsocketManager_is_connected00);
  tolua_endmodule(tolua_S);
 tolua_endmodule(tolua_S);
 return 1;
}


#if defined(LUA_VERSION_NUM) && LUA_VERSION_NUM >= 501
 TOLUA_API int luaopen_WebsocketManager (lua_State* tolua_S) {
 return tolua_WebsocketManager_open(tolua_S);
};
#endif

