/*
 * WebsocketManager.h
 *
 *  Created on: 2013-4-24
 *      Author: edwardzhou
 */

#ifndef WEBSOCKETMANAGER_H_
#define WEBSOCKETMANAGER_H_

#include "cocos2d.h"
#include "boost/tuple/tuple.hpp"
#include "CCLuaEngine.h"
#include "queue"
#include "boost/shared_ptr.hpp"


#define WEBSOCKET_EVENT_OPEN 		1
#define WEBSOCKET_EVENT_CLOSE 		2
#define WEBSOCKET_EVENT_MESSAGE 	3
#define WEBSOCKET_EVENT_ERROR 		4


#ifndef LUA_FUNCTION
typedef int LUA_FUNCTION;
#endif

typedef int WEBSOCKET_ID;

typedef boost::tuple<int, int, int, std::string> WebsocketMessage;
typedef std::queue<WebsocketMessage> WebsocketMessageArray;

enum WebsocketState {
	wsInvalid = 0,
	wsConnecting = 1,
	wsConnected,
	wsClosed,
	wsError
};

//typedef struct {
//	int on_open_scripting_handler;
//	int on_close_scripting_handler;
//	int on_message_scripting_handler;
//	int on_error_scripting_handler;
//	WebsocketState state;
//} WebsocketHandlers;

class WebsocketHandlers {
public:
	WebsocketHandlers();
	WebsocketHandlers(const WebsocketHandlers& copyHandlers);
	virtual ~WebsocketHandlers();

	int on_open_scripting_handler;
	int on_close_scripting_handler;
	int on_message_scripting_handler;
	int on_error_scripting_handler;
	WebsocketState state;
	std::string url;
	WEBSOCKET_ID _websocket_id;
	std::string _receiving_msg;
	bool running;
	std::vector<std::string> _send_buffer;
	void * _c_context;
	void * _c_wsi;
};

class uri_exception : public std::exception {
public:
    uri_exception(const std::string& msg) : m_msg(msg) {}
    ~uri_exception() throw() {}

    virtual const char* what() const throw() {
        return m_msg.c_str();
    }
private:
    std::string m_msg;
};

typedef boost::shared_ptr<WebsocketHandlers> WebsocketHandlersPtr;

//typedef std::map<int, WebsocketHandlersPtr> WebsocketHandlerMap;
//typedef boost::container::flat_map<int, WebsocketHandlersPtr> WebsocketHandlerMap;
typedef std::map<int, WebsocketHandlers*> WebsocketHandlerMap;

class WebsocketManager : public cocos2d::CCObject {
protected:
	WebsocketManager();

public:
	virtual ~WebsocketManager();

	static WebsocketManager* sharedWebsocketManager();

	WEBSOCKET_ID connect(const char* uri, LUA_FUNCTION on_open_handler, LUA_FUNCTION on_close_handler, LUA_FUNCTION on_message_handler, LUA_FUNCTION on_error_handler);
	void close(WEBSOCKET_ID websocket);

	bool send(WEBSOCKET_ID websocket, const char* message);

	void update(float dt);

	void close_all_websockets();

	WebsocketState get_websocket_state(WEBSOCKET_ID websocket);
	bool is_connected(WEBSOCKET_ID websocket);

	void on_websocket_event(WEBSOCKET_ID websocket, int event_type, const std::string& data);

private:
	WebsocketMessageArray _messages;
	WebsocketHandlerMap _handler_map;

	cocos2d::CCArray* _websockets;

//	static void* WebsocketThread(void* param);
	static void* C_WebsocketThread(void* param);

//	WebsocketSendSignal send_signal;
//	WebsocketCloseSignal close_signal;

};

#endif /* WEBSOCKETMANAGER_H_ */
