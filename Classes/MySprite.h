#ifndef __MY_SPRITE_H__
#define __MY_SPRITE_H__

#include "cocos2d.h"

class MySprite : public cocos2d::CCSprite {
public:
	static MySprite* createMS(const char* filename);
};

#endif
