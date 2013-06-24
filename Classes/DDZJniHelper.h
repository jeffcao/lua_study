#ifndef _DDZ_JNI_HELPER_H
#define _DDZ_JNI_HELPER_H

#include "cocos2d.h"

class CC_DLL DDZJniHelper : public cocos2d::CCObject {
public:
	virtual void messageJava(const char* text);
	virtual const char* get(const char* text);
};

#endif
