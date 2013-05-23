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
	ccColor3B color = { r, g, b };
	this->mEditBox->setFontColor(color);
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

void CCEditBoxBridge::registerOnTextChange(LUA_FUNCTION fn) {
	this->delegate->registerOnTextChange(fn);
}

void DelegateBridge::editBoxEditingDidBegin(CCEditBox* editBox) {
	this->last_text = editBox->getText();
}
void DelegateBridge::editBoxEditingDidEnd(CCEditBox* editBox) {
	char* cur_text = (char*) (editBox->getText());
	bool equal = strcmp(this->last_text.c_str(), cur_text) == 0;
	if (this->on_text_change_fn != 0 && !equal) {
		CCScriptEngineProtocol* pEngine =
				CCScriptEngineManager::sharedManager()->getScriptEngine();
		CCLuaEngine* pLuaEngine = dynamic_cast<CCLuaEngine*>(pEngine);
		if (pLuaEngine) {
			CCLuaStack* pStack = pLuaEngine->getLuaStack();
			pStack->pushString(this->last_text.c_str());
			pStack->pushString(cur_text);
			pStack->executeFunctionByHandler(this->on_text_change_fn, 2);
			pStack->clean();
		}
	}
}
void DelegateBridge::editBoxTextChanged(CCEditBox* editBox,
		const std::string& text) {

}
void DelegateBridge::editBoxReturn(CCEditBox* editBox) {
}

void DelegateBridge::registerOnTextChange(LUA_FUNCTION fn) {
	this->on_text_change_fn = fn;
}

