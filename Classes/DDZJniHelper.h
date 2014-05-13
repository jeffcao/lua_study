#ifndef _DDZ_JNI_HELPER_H
#define _DDZ_JNI_HELPER_H

#include "cocos2d.h"

class CC_DLL DDZJniHelper : public cocos2d::CCObject {
public:
	DDZJniHelper(){};
	virtual ~DDZJniHelper(){};
	virtual void messageJava(const char* text);
	virtual const char* get(const char* text);
	static DDZJniHelper* create();
	static bool is_onCppMessage;
	static bool is_messageJava;
};

#endif
