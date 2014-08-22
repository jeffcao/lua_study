#include "AppDelegate.h"

#include "cocos2d.h"
#include "script_support/CCScriptSupport.h"
#include "CCLuaEngine.h"
#include "SimpleAudioEngine.h"
//#include "lua++.h"
//#include "WebsocketManager_lua.h"
#include "Downloader_lua.h"
#include "md5_lua.h"
#include "CheckSign_lua.h"
#include "Marquee_lua.h"
#include "CCLuaStack.h"
#include "CCLuaValue.h"
#include "MobClickCpp.h"
#include "MobClickCpp_lua.h"
#include "MobClickCppExtend_lua.h"
#include <algorithm>
#include <vector>
//#include "CCEditBoxBridge_lua.h"
//#include "DialogLayerConvertor_lua.h"
#include "DDZJniHelper_lua.h"
// #include "tolua/luaopen_LuaProxy.h"
// extern "C" {
// #include "cjson/lua_extensions.h"
// #include "luasocket/luasocket.h"
// #include "lua.h"
// }

#include "CheckSign.h"
// #include "Lua_extensions_CCB.h"
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

extern "C"
{
    int cocos2dx_lo_loader(lua_State *L)
    {
        std::string filename(luaL_checkstring(L, 1));
        size_t pos = filename.rfind(".lo");
        if (pos != std::string::npos)
        {
            filename = filename.substr(0, pos);
        }

        pos = filename.find_first_of(".");
        while (pos != std::string::npos)
        {
            filename.replace(pos, 1, "/");
            pos = filename.find_first_of(".");
        }
        filename.append(".lo");

        unsigned long codeBufferSize = 0;
        unsigned char* codeBuffer = CCFileUtils::sharedFileUtils()->getFileData(filename.c_str(), "rb", &codeBufferSize);

        if (codeBuffer)
        {
            if (luaL_loadbuffer(L, (char*)codeBuffer, codeBufferSize, filename.c_str()) != 0)
            {
                luaL_error(L, "error loading module %s from file %s :\n\t%s",
                    lua_tostring(L, 1), filename.c_str(), lua_tostring(L, -1));
            }
            delete []codeBuffer;
        }
        else
        {
            CCLog("can not get file data of %s", filename.c_str());
        }

        return 1;
    }
}

bool AppDelegate::applicationDidFinishLaunching()
{
    // initialize director
    CCDirector *pDirector = CCDirector::sharedDirector();
    pDirector->setOpenGLView(CCEGLView::sharedOpenGLView());
    pDirector->setProjection(kCCDirectorProjection2D);


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

    //tolua_WebsocketManager_open(pLuaState);
    tolua_DDZJniHelper_open(pLuaState);
    //tolua_DialogLayerConvertor_open(pLuaState);
    tolua_Downloader_open(pLuaState);
    tolua_md5_open(pLuaState);
    tolua_MobClickCpp_open(pLuaState);
    tolua_MobClickCpp_extend(pLuaState);
    tolua_CheckSign_open(pLuaState);
    tolua_Marquee_open(pLuaState);
    // luaopen_LuaProxy(pLuaState);
    // luaopen_lua_extensions(pLuaState);
    // tolua_extensions_ccb_open(pLuaState);
    //luaopen_socket_core(pLuaState);
    //CCFileUtils::sharedFileUtils()->addSearchPath("src");

    std::string mainPath = CCFileUtils::sharedFileUtils()->fullPathForFilename("main.lua");
    CCLOG("[DEBUG] mainPath => %s", mainPath.c_str());
    CCLOG("[DEBUG] UserInfo => %s", CCFileUtils::sharedFileUtils()->fullPathForFilename("UserInfo.lua").c_str());

    std::string appid = CCUserDefault::sharedUserDefault()->getStringForKey("appid");
    std::string debug = CCUserDefault::sharedUserDefault()->getStringForKey("debug");
    std::string umeng_app_key =  CCUserDefault::sharedUserDefault()->getStringForKey("umeng_app_key");
    CCLOG("[DEBUG] umeng_app_key => %s", umeng_app_key.c_str());
    MobClickCpp::startWithAppkey(umeng_app_key.c_str(), appid.c_str());
    MobClickCpp::updateOnlineConfig();
    MobClickCpp::setLogEnabled(debug == "true");

    auto pStack = pEngine->getLuaStack();

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID || CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
    //tolua_web_socket_open(pLuaState);
#endif

// #if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
//     CCString* pstrFileContent = CCString::createWithContentsOfFile("main.lua");
//     if (pstrFileContent)
//     {
//         pEngine->executeString(pstrFileContent->getCString());
//     }
//     //pEngine->executeString("require 'main'");
// #else
//     std::string path = CCFileUtils::sharedFileUtils()->fullPathForFilename("main.lua");
//     pEngine->addSearchPath(path.substr(0, path.find_last_of("/")).c_str());
//     pEngine->executeScriptFile(path.c_str());
// #endif

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    // load framework
    pStack->loadChunksFromZIP("framework_precompiled.zip");

    // set script path
    string path = CCFileUtils::sharedFileUtils()->fullPathForFilename("main.lua");
#else
    // load framework
    if (m_projectConfig.isLoadPrecompiledFramework())
    {
        const string precompiledFrameworkPath = SimulatorConfig::sharedDefaults()->getPrecompiledFrameworkPath();
        pStack->loadChunksFromZIP(precompiledFrameworkPath.c_str());
    }

    // set script path
    string path = CCFileUtils::sharedFileUtils()->fullPathForFilename(m_projectConfig.getScriptFileRealPath().c_str());
#endif

    size_t pos;
    while ((pos = path.find_first_of("\\")) != std::string::npos)
    {
        path.replace(pos, 1, "/");
    }
    size_t p = path.find_last_of("/\\");
    if (p != path.npos)
    {
        const string dir = path.substr(0, p);
        pStack->addSearchPath(dir.c_str());

        p = dir.find_last_of("/\\");
        if (p != dir.npos)
        {
            pStack->addSearchPath(dir.substr(0, p).c_str());
        }
    }

    string env = "__LUA_STARTUP_FILE__=\"";
    env.append(path);
    env.append("\"");
    pEngine->executeString(env.c_str());

    CCLOG("------------------------------------------------");
    CCLOG("LOAD LUA FILE: %s", path.c_str());
    CCLOG("------------------------------------------------");
    pEngine->executeScriptFile(path.c_str());


    return true;
}

//添加缓存目录为加载目录
void AppDelegate::setSearchPath()
{
    //CCFileUtils::sharedFileUtils()->addSearchPath("cui");
    CCFileUtils::sharedFileUtils()->addSearchPath("cui/");
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
    std::string cur_path_s = string(cur_path);
    std::string cur_path_s_2  = string(cur_path);
    StringReplace(cur_path_s_2, "?.lua", "?.lo");
    cur_path_s = cur_path_s_2 + ";" + cur_path_s;
    lua_pushfstring(m_state, "%s/?.lo;%s/?.lua;%s", file_path.c_str(),file_path.c_str(), cur_path_s.c_str());
    lua_setfield(m_state, -3, "path");
    lua_pop(m_state, 2);

    m_stack->addLuaLoader(cocos2dx_lo_loader);
}

void AppDelegate::StringReplace(string &strBase, string strSrc, string strDes)
    {
        string::size_type pos = 0;
        string::size_type srcLen = strSrc.size();
        string::size_type desLen = strDes.size();
        pos=strBase.find(strSrc, pos);
        while ((pos != string::npos))
        {
            strBase.replace(pos, srcLen, strDes);
            pos=strBase.find(strSrc, (pos+desLen));
        }
    }

// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground()
{
	CCLOG("AppDelegate::applicationDidEnterBackground");
    CCDirector::sharedDirector()->stopAnimation();
    CCNotificationCenter::sharedNotificationCenter()->postNotification("on_pause");
    CCNotificationCenter::sharedNotificationCenter()->postNotification("APP_ENTER_BACKGROUND_EVENT");
    // if you use SimpleAudioEngine, it must be pause
    _bg_music_playing = SimpleAudioEngine::sharedEngine()->isBackgroundMusicPlaying();
    if (_bg_music_playing)
    	SimpleAudioEngine::sharedEngine()->pauseBackgroundMusic();

    MobClickCpp::applicationDidEnterBackground();
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
	CCLOG("AppDelegate::applicationWillEnterForeground");
    CCDirector::sharedDirector()->startAnimation();
    CCNotificationCenter::sharedNotificationCenter()->postNotification("on_resume");
    CCNotificationCenter::sharedNotificationCenter()->postNotification("APP_ENTER_FOREGROUND_EVENT");
    // if you use SimpleAudioEngine, it must resume here
    if (_bg_music_playing)
        SimpleAudioEngine::sharedEngine()->resumeBackgroundMusic();

    MobClickCpp::applicationWillEnterForeground();
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
