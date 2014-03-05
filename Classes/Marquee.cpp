#include "Marquee.h"
#include "cocos2d.h"
#include "CCLuaEngine.h"
#include "tolua_fix.h"

using namespace cocos2d;

Marquee* Marquee::create() {
	Marquee* marquee = new Marquee();
	return marquee;
}

void Marquee::setTextProvider(LUA_FUNCTION lua_provider) {
	this->_lua_provider = lua_provider;
}

void Marquee::setText(const char* text) {
	this->_text = text;
}

const char* Marquee::getText() {
	if (this->_lua_provider) {
		CCScriptEngineProtocol* pEngine =
				CCScriptEngineManager::sharedManager()->getScriptEngine();
		CCLuaEngine* pLuaEngine = dynamic_cast<CCLuaEngine*>(pEngine);
		CCLuaStack* pStack = pLuaEngine->getLuaStack();

		lua_State* l_state = pStack->getLuaState();
		toluafix_get_function_by_refid(l_state, this->_lua_provider);

		int functionIndex = -1;
		int traceback = 0;
		lua_getglobal(l_state, "__G__TRACKBACK__"); /* L: ... func arg1 arg2 ... G */
		if (!lua_isfunction(l_state, -1)) {
			lua_pop(l_state, 1); /* L: ... func arg1 arg2 ... */
		} else {
			lua_insert(l_state, functionIndex - 1); /* L: ... G func arg1 arg2 ... */
			traceback = functionIndex - 1;
		}

		int error = 0;
		error = lua_pcall(l_state, 0, 1, traceback);
		if (error) {
			if (traceback == 0) {
				CCLOG("[LUA ERROR] %s", lua_tostring(l_state, - 1)); /* L: ... error */
				lua_pop(l_state, 1); // remove error message from stack
			} else /* L: ... G error */
			{
				lua_pop(l_state, 2); // remove __G__TRACKBACK__ and error message from stack
			}
		} else {
			if (lua_type(l_state, -1) == LUA_TSTRING) {
				const char* str_get = lua_tolstring(l_state, -1, NULL);
				if (str_get) {
				//	CCLOG("text get is %s", str_get);
					return str_get;
				}
			}
		}
		pStack->clean();
	}
	return this->_text;
}

void Marquee::setSize(float width, float height) {
	this->_size = CCSizeMake(width, height);
}

void Marquee::enableStroke() {
	this->_stroke_enable = true;
}

void Marquee::enableStroke(int r, int g, int b, int stroke_size) {
	this->_stroke_color = ccc3(r, g, b);
	this->_stroke_size = stroke_size;
	this->enableStroke();
}

void Marquee::setTextSize(int size) {
	this->_text_size = size;
}

void Marquee::setTextColor(int r, int g, int b) {
	this->_text_color = ccc3(r, g, b);
}

void Marquee::setTextFont(const char* font) {
	this->_font = font;
}

CCNode* Marquee::getClipNode() {
	return this->_clip_node;
}

int getTextCount(CCLabelTTF* label) {
	float k = 1.34;
	float h = label->getContentSize().height;
	float count = h / (k * label->getFontSize());
	int count_c = (int) count;
	if (count - (float) count_c >= 0.5) {
		count_c++;
	}
	return count_c;
}

float getTextHeight(CCLabelTTF* label) {
	float h = label->getContentSize().height;
	int count_c = getTextCount(label);
	return h / (float) count_c;
}

float getTextDelta(CCLabelTTF* label) {
	int count_c = getTextCount(label);
	float h = label->getContentSize().height;
	float rise = h / (float) count_c;
	float delta = rise * count_c - h;
	return delta;
}

void Marquee::init(cocos2d::CCLayer* parent, float x, float y) {
	if (this->_clip_node)
		return;
	this->_clip_node = CCClippingNode::create();
	this->_clip_node->setContentSize(this->_size);
	this->_clip_node->setAnchorPoint(ccp(0.5, 0.5));
	parent->addChild(this->_clip_node);
	//this->_clip_node->setPosition(parent->getContentSize().width/2,parent->getContentSize().height/2);
	this->_clip_node->setPosition(x, y);
	CCDrawNode *stencil = CCDrawNode::create();
	CCPoint rectangle[4];
	rectangle[0] = ccp(0, 0);
	rectangle[1] = ccp(this->_clip_node->getContentSize().width, 0);
	rectangle[2] =
			ccp(this->_clip_node->getContentSize().width, this->_clip_node->getContentSize().height);
	rectangle[3] = ccp(0, this->_clip_node->getContentSize().height);
	ccColor4F white = { 0, 255, 255, 255 };
	stencil->drawPolygon(rectangle, 4, white, 1, white);
	this->_clip_node->setStencil(stencil);
	const char* str = this->getText();
	CCLabelTTF *content = CCLabelTTF::create(str, this->_font, this->_text_size,
			CCSizeMake (this->_size.width, 0), kCCTextAlignmentLeft);
	CCLabelTTF *content2 = CCLabelTTF::create(str, this->_font,
			this->_text_size, CCSizeMake (this->_size.width, 0),
			kCCTextAlignmentLeft);
	CCLOG("content height is %f", content->getContentSize().height);
	content->setColor(this->_text_color);
	content2->setColor(this->_text_color);
	if (this->_stroke_enable)
		content->enableStroke(this->_stroke_color, this->_stroke_size);
	content->setAnchorPoint(ccp(0.5, 1));
	content->setTag(1001);

	if (this->_stroke_enable)
		content2->enableStroke(this->_stroke_color, this->_stroke_size);
	content2->setAnchorPoint(ccp(0.5, 1));
	content2->setTag(1002);
	content->setPosition(
			ccp(this->_clip_node->getContentSize().width / 2, this->_clip_node->getContentSize().height));
	this->_clip_node->addChild(content);
	content->runAction(
			CCRepeatForever::create(
				CCSequence::create(
					CCDelayTime::create(2.0),
					CCCallFuncND::create(content, callfuncND_selector(Marquee::before_callback), (void*) this),
					CCMoveBy::create(1.0, ccp(0,getTextHeight(content))),
					CCCallFuncND::create(content, callfuncND_selector(Marquee::after_callback), (void*)this),
					NULL
				)
			)
	);
	content->setUserData((void*) (getTextCount(content)));
	content2->setPosition(ccp(this->_clip_node->getContentSize().width / 2, 0));
	this->_clip_node->addChild(content2);
}

void Marquee::before_callback(CCNode* pSender, void* data) {
	int tag = pSender->getTag() == 1001 ? 1002 : 1001;
	CCLabelTTF* pSucc =
			static_cast<CCLabelTTF*>(pSender->getParent()->getChildByTag(tag));
	Marquee* marquee = (Marquee*) data;

	float delta = getTextDelta(static_cast<CCLabelTTF*>(pSender));
	int s_count = (int) pSender->getUserData();
	//CCLOG("before_callback s_count is %d", s_count);
	s_count--;
	pSender->setUserData((void*) (s_count));
	if (s_count == 0) {
		const char* label_text = pSucc->getString();
		const char* cur_text = marquee->getText();
		if (strcmp(label_text, cur_text) != 0) {
			pSucc->setString(cur_text);
		}
		pSucc->setUserData((void*) (getTextCount(pSucc) + 1));
		pSucc->stopAllActions();
		pSucc->runAction(
				CCRepeatForever::create(
					CCSequence::create(
						CCCallFuncND::create(pSucc, callfuncND_selector(Marquee::before_callback), (void*) data),
						CCMoveBy::create(1.0, ccp(0,getTextHeight(pSucc))),
						CCCallFuncND::create(pSucc, callfuncND_selector(Marquee::after_callback), (void*)data),
						CCDelayTime::create(2.0),
						NULL
					)
				)
		);
	}

}

void Marquee::after_callback(CCNode* pSender, void* data) {
	int s_count = (int) pSender->getUserData();
	//CCLOG("after_callback s_count is %d", s_count);
	if (s_count == 0) {
		pSender->setPosition(
				ccp(pSender->getParent()->getContentSize().width / 2, 0));
				pSender->stopAllActions();
			}
		}
