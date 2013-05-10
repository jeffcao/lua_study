/*
 * WebsocketManager.cpp
 *
 *  Created on: 2013-4-24
 *      Author: edwardzhou
 */

#include "WebsocketManager.h"
#include "libwebsockets.h"
#include "boost/regex.hpp"
#include "boost/thread.hpp"

using namespace cocos2d;

static WebsocketManager* _sharedWebsocketManager = NULL;

boost::mutex _mutex;

//static unsigned int opts;
static int was_closed;
static int deny_deflate;
static int deny_mux;
//static int mirror_lifetime = 0;
static int force_exit = 0;

// TODO: figure out why this fixes horrible linking errors.
static const uint16_t URI_DEFAULT_PORT = 80;
static const uint16_t URI_DEFAULT_SECURE_PORT = 443;


uint16_t get_port_from_string(const std::string& port, bool use_ssl = false)  {
    if (port == "") {
        return (use_ssl ? URI_DEFAULT_SECURE_PORT : URI_DEFAULT_PORT);
    }

    unsigned int t_port = atoi(port.c_str());

    if (t_port > 65535) {
        throw uri_exception("Port must be less than 65535");
    }

    if (t_port == 0) {
        throw uri_exception("Error parsing port string: "+port);
    }

    return static_cast<uint16_t>(t_port);
}

WebsocketHandlers::WebsocketHandlers(){
	this->on_close_scripting_handler = 0;
	this->on_error_scripting_handler = 0;
	this->on_message_scripting_handler = 0;
	this->on_open_scripting_handler = 0;
	this->_websocket_id = 0;
	this->url = "";
	this->state = wsInvalid;
	this->running = false;
	this->_c_context = NULL;
	this->_c_wsi = NULL;


	CCLOG("WebsocketHandlers::WebsocketHandlers(), pointer: 0x%08x", this);
}

WebsocketHandlers::WebsocketHandlers(const WebsocketHandlers& copyHandlers) {
	this->on_close_scripting_handler = copyHandlers.on_close_scripting_handler;
	this->on_error_scripting_handler = copyHandlers.on_error_scripting_handler;
	this->on_message_scripting_handler = copyHandlers.on_message_scripting_handler;
	this->on_open_scripting_handler = copyHandlers.on_open_scripting_handler;
	this->_websocket_id = copyHandlers._websocket_id;
	this->url = copyHandlers.url;
	this->state = copyHandlers.state;
	this->running = copyHandlers.running;
	this->_receiving_msg = copyHandlers._receiving_msg;
	this->_send_buffer = copyHandlers._send_buffer;
	this->_c_context = copyHandlers._c_context;
	this->_c_wsi = copyHandlers._c_wsi;

	CCLOG("WebsocketHandlers::WebsocketHandlers(WebsocketHandlers&), pointer: 0x%08x", this);
}

WebsocketHandlers::~WebsocketHandlers() {

	CCLOG("WebsocketHandlers::~WebsocketHandlers(), pointer: 0x%08x", this);
}


WebsocketManager::WebsocketManager() {
	// TODO Auto-generated constructor stub

	_websockets = CCArray::create();
	_websockets->retain();

}

WebsocketManager::~WebsocketManager() {
	// TODO Auto-generated destructor stub
	CC_SAFE_RELEASE_NULL(_websockets);
}

WebsocketManager* WebsocketManager::sharedWebsocketManager() {
	if ( _sharedWebsocketManager == NULL ) {
		_sharedWebsocketManager = new WebsocketManager();
		CCDirector::sharedDirector()->getScheduler()->scheduleSelector(schedule_selector(WebsocketManager::update), _sharedWebsocketManager, 0, false);
		CCDirector::sharedDirector()->getScheduler()->pauseTarget(_sharedWebsocketManager);
	}

	return _sharedWebsocketManager;
}



WEBSOCKET_ID WebsocketManager::connect(const char* uri, int on_open_handler, int on_close_handler, int on_message_handler, int on_error_handler) {
	pthread_t ntid;
	// WebsocketHandlersPtr handlers(new WebsocketHandlers() );

//	handlers->on_open_scripting_handler = on_open_handler;
//	handlers->on_error_scripting_handler = on_error_handler;
//	handlers->on_close_scripting_handler = on_close_handler;
//	handlers->on_message_scripting_handler = on_message_handler;
//	handlers->url = uri;
//
//	pthread_create(&ntid, NULL, WebsocketManager::WebsocketThread, (void*) handlers.get() ) ;

	WebsocketHandlers* handlers = new WebsocketHandlers();

	handlers->on_open_scripting_handler = on_open_handler;
	handlers->on_error_scripting_handler = on_error_handler;
	handlers->on_close_scripting_handler = on_close_handler;
	handlers->on_message_scripting_handler = on_message_handler;
	handlers->url = uri;

//	pthread_create(&ntid, NULL, WebsocketManager::WebsocketThread, (void*) handlers) ;
//	this->_handler_map[ntid] = handlers;

	pthread_t tmpid;
	pthread_create(&tmpid, NULL,  WebsocketManager::C_WebsocketThread, (void*) handlers) ;
	this->_handler_map[tmpid] = handlers;
	ntid = tmpid;

	return ntid;
}

bool WebsocketManager::send(WEBSOCKET_ID websocket, const char* message) {
	WebsocketHandlers* wsHandlers = NULL;
	try {
		wsHandlers = this->_handler_map.at(websocket);
	} catch (std::out_of_range &e) {
		return false;
	}

	if (wsHandlers->state != wsConnected) {
		CCLOG("[WebsocketManager::send] ERROR: state expected as wsConnected, but got %d", wsHandlers->state);
		return false;
	}

	wsHandlers->_send_buffer.push_back(message);
	//send_signal(websocket, message, (void*)wsHandlers);

	if (wsHandlers->_c_context != NULL) {
		libwebsocket_callback_on_writable((libwebsocket_context*)wsHandlers->_c_context,
				(libwebsocket*)wsHandlers->_c_wsi);
	}


	return true;
}

void WebsocketManager::close(WEBSOCKET_ID websocket) {
	CCLOG("[WebsocketManager::close] close websocket: %d", websocket);
	WebsocketHandlers* wsHandlers = NULL;
	try {
		wsHandlers = this->_handler_map.at(websocket);
	} catch (std::out_of_range &e) {
		return ;
	}

	wsHandlers->running = false;
	//close_signal(websocket, (void*)wsHandlers);
//	if (wsHandlers->_c_context != NULL) {
//		libwebsocket_
//	}
}

void WebsocketManager::update(float dt) {
	if ( this->_messages.empty() ) {
		return;
	}

	//CCLOG("[WebsocketManager::update] entering ...");

	static int i=0;

	boost::lock_guard<boost::mutex> lock(_mutex);

	//CCLOG("[WebsocketManager::update] _message.size => %d ", this->_messages.size());

	CCScriptEngineProtocol* pEngine = CCScriptEngineManager::sharedManager()->getScriptEngine();
	CCLuaEngine* pLuaEngine = dynamic_cast<CCLuaEngine*>(pEngine);

	while (!this->_messages.empty()) {
		WebsocketMessage message = this->_messages.front();
		this->_messages.pop();
		WEBSOCKET_ID websocket_id = message.get<0>();
		int event_type = message.get<1>();
		LUA_FUNCTION func_id = message.get<2>();
		std::string msg_body = message.get<3>();
//		CCLOG("[WebsocketManager::update] socket_id: %d, event_type: %d, func_id: %d, msg_body: %s", websocket_id, event_type, func_id, msg_body.c_str());

//
//		if ( msg_body.find("[[\"websocket_rails.ping") != std::string::npos ) {
//			// send_signal(websocket_id, "[\"websocket_rails.pong\", {} ]" );
//			i++;
//		}

		try {
			WebsocketHandlers* wsHandlers = this->_handler_map.at(websocket_id);

			if (pLuaEngine && func_id) {
				CCLuaStack* pStack = pLuaEngine->getLuaStack();

				pStack->pushInt( websocket_id );
				pStack->pushString( msg_body.c_str() );
				pStack->executeFunctionByHandler(func_id, 2);
				pStack->clean();
			}

			if (event_type == WEBSOCKET_EVENT_CLOSE || event_type == WEBSOCKET_EVENT_ERROR ) {
				if (wsHandlers->on_open_scripting_handler) {
					pEngine->removeScriptHandler(wsHandlers->on_open_scripting_handler);
				}
				if (wsHandlers->on_error_scripting_handler) {
					pEngine->removeScriptHandler(wsHandlers->on_error_scripting_handler);
				}
				if (wsHandlers->on_close_scripting_handler) {
					pEngine->removeScriptHandler(wsHandlers->on_close_scripting_handler);
				}
				if (wsHandlers->on_message_scripting_handler) {
					pEngine->removeScriptHandler(wsHandlers->on_message_scripting_handler);
				}

				this->_handler_map.erase(websocket_id);
				delete wsHandlers ;
			}

		}catch (std::out_of_range &ex) {
			CCLOG("[WebsocketManager::update] out-of-range: %s", ex.what());
		}
	}

	CCDirector::sharedDirector()->getScheduler()->pauseTarget(this);

	//CCLOG("[WebsocketManager::update] leaving ...");
}

void WebsocketManager::on_websocket_event(WEBSOCKET_ID websocket, int event_type, const std::string& data) {
	try{
		WebsocketHandlers* wsHandlers = _handler_map.at(websocket);
		int handler = 0;
		switch ( event_type ) {
		case WEBSOCKET_EVENT_OPEN:
			wsHandlers->state = wsConnected;
			handler = wsHandlers->on_open_scripting_handler;
			break;

		case WEBSOCKET_EVENT_CLOSE:
			wsHandlers->state = wsClosed;
			handler = wsHandlers->on_close_scripting_handler;
			break;

		case WEBSOCKET_EVENT_ERROR:
			wsHandlers->state = wsError;
			handler = wsHandlers->on_error_scripting_handler;
			break;

		case WEBSOCKET_EVENT_MESSAGE:
			handler = wsHandlers->on_message_scripting_handler;
			break;
		}

		if (!handler)
			return;

		boost::lock_guard<boost::mutex> lock(_mutex);
		WebsocketMessage sockMsg(websocket, event_type, handler, data);
		//this->_messages.queue();
		_messages.push( sockMsg );

		//CCLOG("[WebsocketManager::on_websocket_event] _message.size => %d ", this->_messages.size());

		CCDirector::sharedDirector()->getScheduler()->resumeTarget(this);

	} catch( std::out_of_range &e ) {
		CCLOG("got exception: %s ", e.what() );
	}
}

void WebsocketManager::close_all_websockets() {

}

bool WebsocketManager::is_connected(WEBSOCKET_ID websocket) {
	return false;
}

WebsocketState WebsocketManager::get_websocket_state(WEBSOCKET_ID websocket){
	WebsocketState result = wsClosed;
	try{
		WebsocketHandlers* wsHandlers = _handler_map.at(websocket);
		result = wsHandlers->state;
	} catch( std::out_of_range &e ) {
		CCLOG("got exception: %s ", e.what() );
	}

	return result;
}




/* dumb_increment protocol */

static int
callback_dumb_increment(struct libwebsocket_context *context,
			struct libwebsocket *wsi,
			enum libwebsocket_callback_reasons reason,
					       void *user, void *in, size_t len)
{
	WebsocketHandlers* wsHandler = (WebsocketHandlers*) libwebsocket_context_user(context);
	WebsocketManager *websocketManager = WebsocketManager::sharedWebsocketManager();

	unsigned char buf[LWS_SEND_BUFFER_PRE_PADDING + 4*1024 +
						  LWS_SEND_BUFFER_POST_PADDING];
	int l=0;
	int n=0;
	int remaining_payload = 0;

	assert(wsHandler != NULL);

	switch (reason) {

	case LWS_CALLBACK_CLOSED:
		CCLOG("[callback_dumb_increment] LWS_CALLBACK_CLOSED\n");
		was_closed = 1;
		wsHandler->running = false;
		wsHandler->state = wsClosed;
		websocketManager->on_websocket_event(wsHandler->_websocket_id, WEBSOCKET_EVENT_CLOSE, "Connection closed");

		break;

	case LWS_CALLBACK_CLIENT_ESTABLISHED:
		CCLOG("[callback_dumb_increment] Websocket connections established");

		wsHandler->state = wsConnected;
		websocketManager->on_websocket_event(wsHandler->_websocket_id, WEBSOCKET_EVENT_OPEN, "Connection open");

		break;

	case LWS_CALLBACK_CLIENT_RECEIVE:
		((char *)in)[len] = '\0';
		CCLOG("[callback_dumb_increment] rx %d '%s'\n", (int)len, (char *)in);
		wsHandler->_receiving_msg.append((const char *)in);
		remaining_payload = libwebsockets_remaining_packet_payload(wsi);
		if (remaining_payload == 0) {
			std::string msg = wsHandler->_receiving_msg;
			wsHandler->_receiving_msg = "";
			CCLOG("[callback_dumb_increment] complete frame [%d]: '%s'", msg.size(), msg.c_str());
			websocketManager->on_websocket_event(wsHandler->_websocket_id, WEBSOCKET_EVENT_MESSAGE, msg);
		} else {
			CCLOG("[callback_dumb_increment] still remain payload %d", remaining_payload);
		}
		break;

	/* because we are protocols[0] ... */

	case LWS_CALLBACK_CLIENT_CONFIRM_EXTENSION_SUPPORTED:
		if ((strcmp((char const*)in, "deflate-stream") == 0) && deny_deflate) {
			CCLOG("[callback_dumb_increment] denied deflate-stream extension\n");
			return 1;
		}
		if ((strcmp((char const*)in, "deflate-frame") == 0) && deny_deflate) {
			CCLOG("[callback_dumb_increment] denied deflate-frame extension\n");
			return 1;
		}
		if ((strcmp((char const*)in, "x-google-mux") == 0) && deny_mux) {
			CCLOG("[callback_dumb_increment] denied x-google-mux extension\n");
			return 1;
		}

		break;

	case LWS_CALLBACK_CLIENT_WRITEABLE:
		if (wsHandler->state == wsConnected && !wsHandler->_send_buffer.empty()) {
			std::string send_msg = wsHandler->_send_buffer.front();
			wsHandler->_send_buffer.erase(wsHandler->_send_buffer.begin());
			memset(&buf[LWS_SEND_BUFFER_PRE_PADDING + 1], 0, send_msg.size());

			l = sprintf((char*)&buf[LWS_SEND_BUFFER_PRE_PADDING + 1],
					"%s" ,
					send_msg.c_str() );

			//l++;
			CCLOG("[callback_dumb_increment] send data (l=> %d) => %s", l, send_msg.c_str());
			n = libwebsocket_write(wsi, &buf[LWS_SEND_BUFFER_PRE_PADDING+1], l, LWS_WRITE_TEXT);

			if (n < 0)
				return -1;
			if (n < l) {
				CCLOG("Partial write LWS_CALLBACK_CLIENT_WRITEABLE\n");
				return -1;
			}

			// wants next writable notify if still has data want to send
			if (!wsHandler->_send_buffer.empty())
				libwebsocket_callback_on_writable(context, wsi);
		}

		break;


	default:
		break;
	}

	return 0;
}


/* list of supported protocols and callbacks */

static struct libwebsocket_protocols protocols[] = {
	{
		"dumb-increment-protocol",
		callback_dumb_increment,
		0,
		2 * 1024,
	},
	{ NULL, NULL, 0, 0 } /* end */
};

void sighandler(int sig)
{
	force_exit = 1;
}

void* WebsocketManager::C_WebsocketThread(void* param) {

	CCLOG("[WebsocketManager::C_WebsocketThread] entering ...");

	WebsocketManager* pThis = WebsocketManager::sharedWebsocketManager();
	WebsocketHandlers* wsHandler = static_cast<WebsocketHandlers*>(param);

	std::string uri = wsHandler->url;
	std::string host;
	std::string path;

	int n = 0;
	int ret = 0;
	int port = 3000;
	int use_ssl = 0;
	struct libwebsocket_context *context;
	struct libwebsocket *wsi_dumb;
	int ietf_version = -1; /* latest */
	struct lws_context_creation_info info;

	memset(&info, 0, sizeof info);

	pthread_t websocket_id = pthread_self();
	wsHandler->_websocket_id = websocket_id;

    boost::cmatch matches;
    const boost::regex expression("(ws|wss)://([^/:\\[]+|\\[[0-9a-fA-F:.]+\\])(:\\d{1,5})?(/[^#]*)?");

    if (boost::regex_match(uri.c_str(), matches, expression)) {
    	use_ssl = (matches[1] == "wss");
        host = matches[2];

        // strip brackets from IPv6 literal URIs
        if (host[0] == '[') {
        	host = host.substr(1,host.size()-2);
        }

        std::string s_port(matches[3]);

        if (s_port != "") {
            // strip off the :
            // this could probably be done with a better regex.
        	s_port = s_port.substr(1);
        }

        port = get_port_from_string(s_port);

        path = matches[4];

        if (path == "") {
        	path = "/";
        }
    } else {
    	goto bail_exit;
    }

    CCLOG("[WebsocketManager::C_WebsocketThread] host => %s , port => %d, path => %s ",
    		host.c_str(),
    		port,
    		path.c_str());

    try {
    	wsHandler->state = wsConnecting;
    	wsHandler->running = true;

		/*
		 * create the websockets context.  This tracks open connections and
		 * knows how to route any traffic and which protocol version to use,
		 * and if each connection is client or server side.
		 *
		 * For this client-only demo, we tell it to not listen on any port.
		 */

		info.port = CONTEXT_PORT_NO_LISTEN;
		info.protocols = protocols;
		info.user = (void *)wsHandler;

	#ifndef LWS_NO_EXTENSIONS
		info.extensions = libwebsocket_get_internal_extensions();
	#endif
		info.gid = -1;
		info.uid = -1;

		context = libwebsocket_create_context(&info);
		if (context == NULL) {
			CCLOG("Creating libwebsocket context failed\n");
			return NULL;
		}


		/* create a client websocket using dumb increment protocol */

		wsi_dumb = libwebsocket_client_connect(context, host.c_str(), port, use_ssl,
				path.c_str(), host.c_str() , host.c_str(),
				 protocols[0].name, ietf_version);

		if (wsi_dumb == NULL) {
			CCLOG("libwebsocket dumb connect failed");
			wsHandler->state = wsError;
			pThis->on_websocket_event(websocket_id, WEBSOCKET_EVENT_ERROR, "Connection failed.");

			ret = 1;
			goto bail;
		}

		wsHandler->_c_context = context;
		wsHandler->_c_wsi = wsi_dumb;

		CCLOG("Websocket connections opened");

		n = 0;
		while (n >= 0 && wsHandler->running && !force_exit) {
			n = libwebsocket_service(context, 100);

			// other looping stuff here...
		}

		bail:
			CCLOG("Exit....!");
			libwebsocket_context_destroy(context);

    } catch (std::exception& e) {
    	CCLOG("[WebsocketManager::C_WebsocketThread] Exception: %s", e.what());
    }

    bail_exit:

	CCLOG("[WebsocketManager::WebsocketThread] leaving ...");
}

