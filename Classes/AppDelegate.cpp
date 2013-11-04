#include "AppDelegate.h"

#include "cocos2d.h"
#include "script_support/CCScriptSupport.h"
#include "CCLuaEngine.h"
#include "SimpleAudioEngine.h"
//#include "lua++.h"
#include "WebsocketManager_lua.h"
#include "Downloader_lua.h"
#include "md5_lua.h"
#include "CCLuaStack.h"
#include "CCLuaValue.h"
#include <vector>
//#include "CCEditBoxBridge_lua.h"
#include "DialogLayerConvertor_lua.h"
#include "DDZJniHelper_lua.h"
#include "tolua/luaopen_LuaProxy.h"
extern "C" {
#include "cjson/lua_extensions.h"
#include "luasocket/luasocket.h"
#include "lua.h"
}

#include "Lua_extensions_CCB.h"
#include "support/CCNotificationCenter.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
#include "Lua_web_socket.h"
#endif



USING_NS_CC;

using namespace CocosDenshion;
using namespace std;

bool _bg_music_playing = false;

AppDelegate::AppDelegate()
{
	setSearchPath();
}

AppDelegate::~AppDelegate()
{
}

bool AppDelegate::applicationDidFinishLaunching()
{
    // initialize director
    CCDirector *pDirector = CCDirector::sharedDirector();
    pDirector->setOpenGLView(CCEGLView::sharedOpenGLView());


    CCSize screenSize = CCEGLView::sharedOpenGLView()->getFrameSize();

    //CCSize designSize = CCSizeMake(480, 320);
    CCSize designSize = CCSizeMake(800, 480);
    //CCSize designSize = CCSizeMake(960, 540);
    CCSize resourceSize = CCSizeMake(800, 480);

    std::vector<std::string> resDirOrders;

    TargetPlatform platform = CCApplication::sharedApplication()->getTargetPlatform();
    if (platform == kTargetIphone || platform == kTargetIpad)
    {
        if (screenSize.width > 1024)
        {
            resourceSize = CCSizeMake(2048, 1536);
            resDirOrders.push_back("resources-ipadhd");
            resDirOrders.push_back("resources-ipad");
            resDirOrders.push_back("resources-iphonehd");
        }
        else if (screenSize.width > 960)
        {
            resourceSize = CCSizeMake(1024, 768);
            resDirOrders.push_back("resources-ipad");
            resDirOrders.push_back("resources-iphonehd");
        }
        else if (screenSize.width > 480)
        {
            resourceSize = CCSizeMake(960, 640);
            resDirOrders.push_back("resources-iphonehd");
            resDirOrders.push_back("resources-iphone");
        }
        else
        {
            resourceSize = CCSizeMake( 480, 320);
            resDirOrders.push_back("resources-iphone");
        }

    }
    else if (platform == kTargetAndroid || platform == kTargetWindows)
    {
        if (screenSize.width > 960)
        {
            resourceSize = CCSizeMake(1920, 1280);
            resDirOrders.push_back("resources-xlarge");
            resDirOrders.push_back("resources-large");
            resDirOrders.push_back("resources-medium");
            resDirOrders.push_back("resources-small");
        }
		else if (screenSize.width > 960) {
			resourceSize = CCSizeMake(1024, 552);
			//resourceSize = CCSizeMake(960, 640);
			resDirOrders.push_back("resources-xlarge");
			resDirOrders.push_back("resources-large");
			resDirOrders.push_back("resources-medium");
			resDirOrders.push_back("resources-small");
		}
//        else if (screenSize.width > 800) {
//            resourceSize = CCSizeMake(960, 540);
//            //resourceSize = CCSizeMake(960, 640);
////            resDirOrders.push_back("resources-xlarge");
//            resDirOrders.push_back("resources-large");
//            resDirOrders.push_back("resources-medium");
//            resDirOrders.push_back("resources-small");
//        }
        else if (screenSize.width > 720)
        {
            resourceSize = CCSizeMake(800, 480);
            //resourceSize = CCSizeMake(960, 640);
            //resDirOrders.push_back("resources-xlarge");
            //resDirOrders.push_back("resources-large");
            resDirOrders.push_back("resources-medium");
            resDirOrders.push_back("resources-small");
        }
        else if (screenSize.width > 480)
        {
            resourceSize = CCSizeMake(720, 480);
            resDirOrders.push_back("resources-medium");
            resDirOrders.push_back("resources-small");
        }
        else
        {
            resourceSize = CCSizeMake(480, 320);
            resDirOrders.push_back("resources-medium");
            resDirOrders.push_back("resources-small");
        }
    }

    CCFileUtils::sharedFileUtils()->setSearchResolutionsOrder(resDirOrders);
    float scaleFactor = designSize.width * 1.0 / resourceSize.width;
    scaleFactor = resourceSize.width * 1.0 / designSize.width;
    //scaleFactor = 1.0;
    pDirector->setContentScaleFactor( scaleFactor );
    CCEGLView::sharedOpenGLView()->setDesignResolutionSize(designSize.width,
    		designSize.height,
    		kResolutionExactFit);

    // turn on display FPS
    // pDirector->setDisplayStats(true);

    // set FPS. the default value is 1.0/60 if you don't call this
    pDirector->setAnimationInterval(1.0 / 60);

    CCLuaEngine* pEngine = CCLuaEngine::defaultEngine();
    CCScriptEngineManager::sharedManager()->setScriptEngine(pEngine);

    lua_State* pLuaState = pEngine->getLuaStack()->getLuaState();

    tolua_WebsocketManager_open(pLuaState);
    tolua_DDZJniHelper_open(pLuaState);
    tolua_DialogLayerConvertor_open(pLuaState);
    tolua_Downloader_open(pLuaState);
    tolua_md5_open(pLuaState);
    luaopen_LuaProxy(pLuaState);
    luaopen_lua_extensions(pLuaState);
    tolua_extensions_ccb_open(pLuaState);
    //luaopen_socket_core(pLuaState);
    //CCFileUtils::sharedFileUtils()->addSearchPath("src");

    std::string mainPath = CCFileUtils::sharedFileUtils()->fullPathForFilename("main.lua");
    CCLOG("[DEBUG] mainPath => %s", mainPath.c_str());
    CCLOG("[DEBUG] UserInfo => %s", CCFileUtils::sharedFileUtils()->fullPathForFilename("UserInfo.lua").c_str());

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
    tolua_web_socket_open(pLuaState);
#endif

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    CCString* pstrFileContent = CCString::createWithContentsOfFile("main.lua");
    if (pstrFileContent)
    {
        pEngine->executeString(pstrFileContent->getCString());
    }
#else
    std::string path = CCFileUtils::sharedFileUtils()->fullPathForFilename("main.lua");
    pEngine->addSearchPath(path.substr(0, path.find_last_of("/")).c_str());
    pEngine->executeScriptFile(path.c_str());
#endif

//    // create a scene. it's an autorelease object
//    CCScene *pScene = HelloWorld::scene();
//
//    // run
//    pDirector->runWithScene(pScene);

    /*std::string pathToSave = CCFileUtils::sharedFileUtils()->getWritablePath();
    std::string url = "http://www.daemonology.net/bsdiff/bsdiff-4.3.tar.gz";
    std::string name = "bsdiff-4.3.tar.gz";
    CCLOG("[DEBUG] pathToSave => %s", pathToSave.c_str());
    Downloader *d = new Downloader(url.c_str(), pathToSave.c_str(), name.c_str());
    d->setDelegate(new DownloadListener());
    d->update();
    CCLOG("download run");*/
  //  setSearchPath();
    return true;
}

//添加缓存目录为加载目录
void AppDelegate::setSearchPath()
{
	vector<string> searchPaths = CCFileUtils::sharedFileUtils()->getSearchPaths();
    vector<string>::iterator iter = searchPaths.begin();
    std::string file_path = CCFileUtils::sharedFileUtils()->getWritablePath() + "resources";
    searchPaths.insert(iter, file_path);
    CCFileUtils::sharedFileUtils()->setSearchPaths(searchPaths);

    //CCFileUtils:sharedFileUtils():purgeCachedEntries()

    //set path in lua priorer than default path
    CCLuaEngine* lua_engine = CCLuaEngine::defaultEngine();
    CCLuaStack* m_stack = lua_engine->getLuaStack();
    lua_State* m_state = m_stack->getLuaState();
    lua_getglobal(m_state, "package");
    lua_getfield(m_state, -1, "path");
    const char* cur_path =  lua_tostring(m_state, -1);
    lua_pushfstring(m_state, "%s/?.lua;%s", file_path.c_str(), cur_path);
    lua_setfield(m_state, -3, "path");
    lua_pop(m_state, 2);
}

// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground()
{
    CCDirector::sharedDirector()->pause();
    CCNotificationCenter::sharedNotificationCenter()->postNotification("on_pause");
    // if you use SimpleAudioEngine, it must be pause
    _bg_music_playing = SimpleAudioEngine::sharedEngine()->isBackgroundMusicPlaying();
    if (_bg_music_playing)
    	SimpleAudioEngine::sharedEngine()->pauseBackgroundMusic();

}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
    CCDirector::sharedDirector()->resume();
    CCNotificationCenter::sharedNotificationCenter()->postNotification("on_resume");
    // if you use SimpleAudioEngine, it must resume here
    if (_bg_music_playing)
        SimpleAudioEngine::sharedEngine()->resumeBackgroundMusic();
}

/*void DownloadListener::onError(Downloader::ErrorCode errorCode) {
CCLOG("DownloadListener::onError => %d, %d", errorCode, Downloader::kCreateFile);
}
void DownloadListener::onProgress(int percent){
	CCLOG("DownloadListener::onProgress");
}
void DownloadListener::onSuccess(){
	CCLOG("DownloadListener::onSuccess");
}*/
