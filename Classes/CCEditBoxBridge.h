#ifndef CCEDITBOXBRIDGE_H_
#define CCEDITBOXBRIDGE_H_

#include "cocos2d.h"
#include "cocos-ext.h"

typedef cocos2d::CCNode CCNode;

class CCEditBoxBridge : public cocos2d::CCObject{

public:
	CCEditBoxBridge():mEditBox(NULL){}
	virtual ~CCEditBoxBridge(){};

	static CCEditBoxBridge* create(const char* plist_name, const char* normal9scale, int width, int height);

	void addTo(CCNode* node, int x, int y);

private:
	cocos2d::extension::CCEditBox* mEditBox;
};


#endif
