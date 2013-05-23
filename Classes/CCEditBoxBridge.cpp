#include "CCEditBoxBridge.h"

using namespace cocos2d;
using namespace cocos2d::extension;

CCEditBoxBridge* CCEditBoxBridge::create(const char* plist_name,
		const char* normal9scale, int width, int height) {
	CCSpriteFrameCache* cache = CCSpriteFrameCache::sharedSpriteFrameCache();
	cache->addSpriteFramesWithFile(plist_name);
	CCScale9Sprite* frame_9_normal = CCScale9Sprite::createWithSpriteFrameName(
			normal9scale);
	CCEditBoxBridge* bridge = new CCEditBoxBridge();
	bridge->mEditBox = CCEditBox::create(CCSizeMake(width, height),
			frame_9_normal);
	bridge->delegate = new DelegateBridge();
	bridge->mEditBox->setDelegate(bridge->delegate);
	return bridge;
}

void CCEditBoxBridge::addTo(CCNode* node, int x, int y) {
	node->addChild(mEditBox);
	mEditBox->setPosition(ccp(x,y));
}

void CCEditBoxBridge::setHint(const char* hint) {
	this->mEditBox->setPlaceHolder(hint);
}

void CCEditBoxBridge::setHintSize(int fontSize) {
	this->mEditBox->setPlaceholderFontSize(fontSize);
}

void CCEditBoxBridge::setText(const char* text) {
	this->mEditBox->setText(text);
}

const char* CCEditBoxBridge::getText() {
	return this->mEditBox->getText();
}

void CCEditBoxBridge::setTextSize(int fontSize) {
	this->mEditBox->setFontSize(fontSize);
}

void CCEditBoxBridge::setTextColor(int r, int g, int b) {
	ccColor3B color = {r,g,b};
	this->mEditBox->setFontColor( color);
}

void CCEditBoxBridge::setInputFlag(int flag) {
	switch (flag) {
	case 0:
		this->mEditBox->setInputFlag(kEditBoxInputFlagPassword);
		break;
	}
}

void CCEditBoxBridge::setMaxLength(int max) {
	this->mEditBox->setMaxLength(max);
}

void DelegateBridge::editBoxEditingDidBegin(CCEditBox* editBox) {
	CCLog("editBox %p DidBegin !", editBox);
}
void DelegateBridge::editBoxEditingDidEnd(CCEditBox* editBox) {
	CCLog("editBox %p DidEnd !", editBox);
}
void DelegateBridge::editBoxTextChanged(CCEditBox* editBox,
		const std::string& text) {
	CCLog("editBox %p TextChanged, text: %s ", editBox, text.c_str());

}
void DelegateBridge::editBoxReturn(CCEditBox* editBox) {
	CCLog("editBox %p was returned !");
}

