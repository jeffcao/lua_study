#include "MySprite.h"

MySprite* MySprite::createMS(const char* filename) {
	MySprite* sp = new MySprite();
	if (sp && sp->initWithFile(filename)) {
		sp->setPosition(ccp(100,100));
		sp->autorelease();
		return sp;
	}
	CC_SAFE_DELETE(sp);
	return NULL;
}
