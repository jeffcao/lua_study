#include "DialogLayerConvertor.h"

using namespace cocos2d;

DialogLayerConvertor* DialogLayerConvertor::create(CCArray* menus) {
	DialogLayerConvertor* convertor = new DialogLayerConvertor();
	convertor->delegater = new TouchDelegater();

		CCObject* pObj = NULL;
		CCARRAY_FOREACH(menus, pObj) {
			CCMenu* cmenu = dynamic_cast<CCMenu*>(pObj);
			convertor->delegater->addMenu(cmenu);
		}
		return convertor;
}

void DialogLayerConvertor::convert() {
	CCTouchDispatcher* dispatcher =
					CCDirector::sharedDirector()->getTouchDispatcher();
	dispatcher->addTargetedDelegate(this->delegater, kCCMenuHandlerPriority - 1,
			true);
}
void DialogLayerConvertor::unconvert() {
	CCTouchDispatcher* dispatcher =
			CCDirector::sharedDirector()->getTouchDispatcher();
	dispatcher->removeDelegate(this->delegater);
}

bool TouchDelegater::ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent) {
	this->pTouchedMenu = NULL;
	CCObject* pObj = NULL;
	CCARRAY_FOREACH(this->m_menus, pObj) {
		CCMenu* cmenu = dynamic_cast<CCMenu*>(pObj);
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

void TouchDelegater::addMenu(CCMenu *menu) {
	this->m_menus->addObject(menu);
}
