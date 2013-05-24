/*
** Lua binding: DialogLayerConvertor
** Generated automatically by tolua++-1.0.93 on Fri May 24 14:12:20 2013.
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

#include "DialogLayerConvertor.h"
/* Exported function */
TOLUA_API int  tolua_DialogLayerConvertor_open (lua_State* tolua_S);


/* function to register type */
static void tolua_reg_types (lua_State* tolua_S)
{
 tolua_usertype(tolua_S,"CCArray");
 tolua_usertype(tolua_S,"DialogLayerConvertor");
 tolua_usertype(tolua_S,"cocos2d::Object");
}

/* method: create of class  DialogLayerConvertor */
#ifndef TOLUA_DISABLE_tolua_DialogLayerConvertor_DialogLayerConvertor_create00
static int tolua_DialogLayerConvertor_DialogLayerConvertor_create00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertable(tolua_S,1,"DialogLayerConvertor",0,&tolua_err) ||
     !tolua_isusertype(tolua_S,2,"CCArray",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,3,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  CCArray* menus = ((CCArray*)  tolua_tousertype(tolua_S,2,0));
  {
   DialogLayerConvertor* tolua_ret = (DialogLayerConvertor*)  DialogLayerConvertor::create(menus);
    tolua_pushusertype(tolua_S,(void*)tolua_ret,"DialogLayerConvertor");
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

/* method: convert of class  DialogLayerConvertor */
#ifndef TOLUA_DISABLE_tolua_DialogLayerConvertor_DialogLayerConvertor_convert00
static int tolua_DialogLayerConvertor_DialogLayerConvertor_convert00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"DialogLayerConvertor",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  DialogLayerConvertor* self = (DialogLayerConvertor*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'convert'", NULL);
#endif
  {
   self->convert();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'convert'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* method: unconvert of class  DialogLayerConvertor */
#ifndef TOLUA_DISABLE_tolua_DialogLayerConvertor_DialogLayerConvertor_unconvert00
static int tolua_DialogLayerConvertor_DialogLayerConvertor_unconvert00(lua_State* tolua_S)
{
#ifndef TOLUA_RELEASE
 tolua_Error tolua_err;
 if (
     !tolua_isusertype(tolua_S,1,"DialogLayerConvertor",0,&tolua_err) ||
     !tolua_isnoobj(tolua_S,2,&tolua_err)
 )
  goto tolua_lerror;
 else
#endif
 {
  DialogLayerConvertor* self = (DialogLayerConvertor*)  tolua_tousertype(tolua_S,1,0);
#ifndef TOLUA_RELEASE
  if (!self) tolua_error(tolua_S,"invalid 'self' in function 'unconvert'", NULL);
#endif
  {
   self->unconvert();
  }
 }
 return 0;
#ifndef TOLUA_RELEASE
 tolua_lerror:
 tolua_error(tolua_S,"#ferror in function 'unconvert'.",&tolua_err);
 return 0;
#endif
}
#endif //#ifndef TOLUA_DISABLE

/* Open function */
TOLUA_API int tolua_DialogLayerConvertor_open (lua_State* tolua_S)
{
 tolua_open(tolua_S);
 tolua_reg_types(tolua_S);
 tolua_module(tolua_S,NULL,0);
 tolua_beginmodule(tolua_S,NULL);
  tolua_cclass(tolua_S,"DialogLayerConvertor","DialogLayerConvertor","cocos2d::Object",NULL);
  tolua_beginmodule(tolua_S,"DialogLayerConvertor");
   tolua_function(tolua_S,"create",tolua_DialogLayerConvertor_DialogLayerConvertor_create00);
   tolua_function(tolua_S,"convert",tolua_DialogLayerConvertor_DialogLayerConvertor_convert00);
   tolua_function(tolua_S,"unconvert",tolua_DialogLayerConvertor_DialogLayerConvertor_unconvert00);
  tolua_endmodule(tolua_S);
 tolua_endmodule(tolua_S);
 return 1;
}


#if defined(LUA_VERSION_NUM) && LUA_VERSION_NUM >= 501
 TOLUA_API int luaopen_DialogLayerConvertor (lua_State* tolua_S) {
 return tolua_DialogLayerConvertor_open(tolua_S);
};
#endif

