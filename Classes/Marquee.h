#ifndef _MARQUEE_H_
#define _MARQUEE_H_
#include "cocos2d.h"

#ifndef LUA_FUNCTION
typedef int LUA_FUNCTION;
#endif

	class Marquee: public cocos2d::CCObject {
		Marquee():_text(""), _size(cocos2d::CCSizeMake(200,27)),
				_stroke_size(2), _stroke_color(cocos2d::ccc3(0,0,0)),
				_text_size(24), _text_color(cocos2d::ccc3(255,212,63)),
				_clip_node(NULL), _font("Marker Felt"),
				_stroke_enable(false){};
		virtual ~Marquee(){};
	public:
		static Marquee* create();

		void setSize(float width, float height);
		void enableStroke();
		void enableStroke(int r, int g, int b, int stroke_size);
		void setTextSize(int size);
		void setTextColor(int r, int g, int b);
		void setTextFont(const char* font);

		void setText(const char* text);
		void init(cocos2d::CCLayer* parent, float x, float y);

		cocos2d::CCNode* getClipNode();

		void setTextProvider(LUA_FUNCTION lua_provider);

	protected:
		const char* getText();
		void before_callback(cocos2d::CCNode* pSender, void* data);
		void after_callback(cocos2d::CCNode* pSender, void* data);

	private:
		const char* _text;
		cocos2d::CCSize _size;
		int _stroke_size;
		int _text_size;
		const char* _font;
		bool _stroke_enable;
		int _lua_provider;
		cocos2d::ccColor3B _text_color;
		cocos2d::ccColor3B _stroke_color;
		cocos2d::CCClippingNode* _clip_node;
	};
#endif
