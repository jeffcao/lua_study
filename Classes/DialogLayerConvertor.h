#ifndef DIALOGLAYERCONVERTOR_H_
#define DIALOGLAYERCONVERTOR_H_

#include "cocos2d.h"

typedef cocos2d::CCArray CCArray;

class TouchDelegater: public cocos2d::CCObject, public cocos2d::CCTouchDelegate {
public:
	TouchDelegater() : m_menus(new cocos2d::CCArray), pTouchedMenu(NULL) {};
	~TouchDelegater() {};

	virtual bool ccTouchBegan(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent);
	virtual void ccTouchMoved(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent);
	virtual void ccTouchEnded(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent);
	virtual void ccTouchCancelled(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent);

	void addMenu(cocos2d::CCLayer* menu);

private:
	cocos2d::CCArray *m_menus;
	cocos2d::CCLayer *pTouchedMenu;
};

class DialogLayerConvertor : public cocos2d::CCObject {
public:
	DialogLayerConvertor() : delegater(NULL), _count(1) {};
	virtual ~DialogLayerConvertor() {};

	static DialogLayerConvertor* create(CCArray* menus);
	void convert();
	void unconvert();
	static void purgeTouchDispatcher();

private:
	TouchDelegater* delegater;
	int _count;
};

#endif /* DIALOGLAYERCONVERTOR_H_ */
