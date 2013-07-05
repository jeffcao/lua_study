#include "DialogLayerConvertor.h"

using namespace cocos2d;

DialogLayerConvertor* DialogLayerConvertor::create(CCArray* menus) {
	DialogLayerConvertor* convertor = new DialogLayerConvertor();
	convertor->delegater = new TouchDelegater();
	CCObject* pObj = NULL;
	CCARRAY_FOREACH(menus, pObj) {
		CCLayer* cmenu = dynamic_cast<CCLayer*>(pObj);
		convertor->delegater->addMenu(cmenu);
	}
	return convertor;
}

void DialogLayerConvertor::convert() {
	CCTouchDispatcher* dispatcher =
			CCDirector::sharedDirector()->getTouchDispatcher();
	dispatcher->addTargetedDelegate(this->delegater, kCCMenuHandlerPriority - this->_count,
			true);
	this->_count = this->_count + 1;
}

void DialogLayerConvertor::unconvert() {
	CCTouchDispatcher* dispatcher =
			CCDirector::sharedDirector()->getTouchDispatcher();
	dispatcher->removeDelegate(this->delegater);
	this->_count = this->_count - 1;
	if (this->_count < 1) {
		this->_count = 1;
	}
}

void DialogLayerConvertor::purgeTouchDispatcher() {
	CCTouchDispatcher* dispatcher =
				CCDirector::sharedDirector()->getTouchDispatcher();
	dispatcher->removeAllDelegates();
}

bool TouchDelegater::ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent) {
	this->pTouchedMenu = NULL;
	CCObject* pObj = NULL;
	CCARRAY_FOREACH(this->m_menus, pObj) {
		CCLayer* cmenu = dynamic_cast<CCLayer*>(pObj);
		if (cmenu->ccTouchBegan(pTouch, pEvent)) {
			this->pTouchedMenu = cmenu;
			break;
		}
	}
	return true;
}

void TouchDelegater::ccTouchMoved(CCTouch *pTouch, CCEvent *pEvent) {
	if (this->pTouchedMenu) {
		this->pTouchedMenu->ccTouchMoved(pTouch, pEvent);
	}
}

void TouchDelegater::ccTouchEnded(CCTouch *pTouch, CCEvent *pEvent) {
	if (this->pTouchedMenu) {
		this->pTouchedMenu->ccTouchEnded(pTouch, pEvent);
	}
}

void TouchDelegater::ccTouchCancelled(CCTouch *pTouch, CCEvent *pEvent) {
	if (this->pTouchedMenu) {
		this->pTouchedMenu->ccTouchCancelled(pTouch, pEvent);
	}
}

void TouchDelegater::addMenu(CCLayer *menu) {
	this->m_menus->addObject(menu);
}
