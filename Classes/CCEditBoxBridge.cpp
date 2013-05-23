#include "CCEditBoxBridge.h"

using namespace cocos2d;
using namespace cocos2d::extension;

CCEditBoxBridge* CCEditBoxBridge::create(const char* plist_name,
		const char* normal9scale, int width,
		int height) {
	CCSpriteFrameCache* cache = CCSpriteFrameCache::sharedSpriteFrameCache();
	cache->addSpriteFramesWithFile(plist_name);
	CCScale9Sprite* frame_9_normal = CCScale9Sprite::createWithSpriteFrameName(normal9scale);
	CCEditBoxBridge* bridge = new CCEditBoxBridge();
	bridge->mEditBox = CCEditBox::create(CCSizeMake(width, height), frame_9_normal);
	bridge->mEditBox->setPlaceHolder("place holder");
	return bridge;
}

void CCEditBoxBridge::addTo(CCNode* node, int x, int y) {
	node -> addChild(mEditBox);
	mEditBox -> setPosition(ccp(x,y));
}
