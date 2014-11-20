#include "AppDelegate.h"

#include "cocos2d.h"
#include "script_support/CCScriptSupport.h"
#include "extensions/AssetsManager/AssetsManager.h"
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

#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#endif

#include "support/zip_support/unzip.h"

#define BUFFER_SIZE    8192
#define MAX_FILENAME   512

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
    auto fileUtils = CCFileUtils::sharedFileUtils();

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
    std::string w_able_path = fileUtils->getWritablePath()+"cui";

    unsigned long l = 0;
    auto self_cui_ver = fileUtils->getFileData("cur_ver.txt", "r", &l);
    auto dst_cui_ver_file = w_able_path + "/cui_ver.txt";
    auto needUpdateCUI = true;
    auto dst_cui_exists = IsDirExistAndCreate(w_able_path.c_str());

    do {
        if (!dst_cui_exists) {
            createDirectory(w_able_path.c_str());
            break;
        }

        if (!fileUtils->isFileExist(dst_cui_ver_file))
            break;

        auto dst_cui_ver = fileUtils->getFileData(dst_cui_ver_file.c_str(), "r", &l);
        if (dst_cui_ver == NULL || strcmp((char const*)self_cui_ver, (char const*)dst_cui_ver) != 0)
            break;

        needUpdateCUI = false;

    } while (0);


    if (needUpdateCUI)
    {
        //First - get asset file data:
        // mode_t processMask = umask(0);

        // int ret = mkdir(w_able_path.c_str(), S_IRWXU | S_IRWXG | S_IRWXO);
        // umask(processMask);
        // if (ret != 0 && (errno != EEXIST))
        // {
        //     CCLog("AppDelegate::applicationDidEnterBackground, create resources failed.");
        // }

#if DDZ_DEBUG > 0
          CCLog("**********DDZ_DEBUG*********");
#else
          CCLog("**********DDZ_RELEASE********");

        std::string s_file = "zipres/cui.dat";
        CCLog("AppDelegate::applicationDidEnterBackground, s_file => %s", s_file.c_str());
        unsigned long codeBufferSize = 0;
        unsigned char* zip_data = CCFileUtils::sharedFileUtils()->getFileData(s_file.c_str(), "rb", &codeBufferSize);

        //second - save it:
        string dest_path = w_able_path + "/cui.zip";
        CCLog("AppDelegate::applicationDidEnterBackground, dest_path => %s", dest_path.c_str());
        FILE* dest = fopen(dest_path.c_str(), "wb");

        CCLog("AppDelegate::applicationDidEnterBackground, begin write cui.dat");

        fwrite(zip_data, codeBufferSize, 1, dest);
        fclose(dest);

        CCLog("AppDelegate::applicationDidEnterBackground, end write cui.dat");

        uncompress(w_able_path.c_str(), dest_path.c_str());
        remove(dest_path.c_str());
        w_able_path = CCFileUtils::sharedFileUtils()->getWritablePath()+"resources";
        createDirectory(w_able_path.c_str());
        w_able_path = CCFileUtils::sharedFileUtils()->getWritablePath()+"resources/res";
        //First - get asset file data:
        createDirectory(w_able_path.c_str());
        s_file = "zipres/res.dat";
        CCLog("AppDelegate::applicationDidEnterBackground, s_file => %s", s_file.c_str());
        codeBufferSize = 0;
        zip_data = CCFileUtils::sharedFileUtils()->getFileData(s_file.c_str(), "rb", &codeBufferSize);


        dest_path = w_able_path + "/res.zip";
        CCLog("AppDelegate::applicationDidEnterBackground, dest_path => %s", dest_path.c_str());
        dest = fopen(dest_path.c_str(), "wb");

        CCLog("AppDelegate::applicationDidEnterBackground, begin write res.dat");

        fwrite(zip_data, codeBufferSize, 1, dest);
        fclose(dest);

        CCLog("AppDelegate::applicationDidEnterBackground, end write res.dat");

        // cocos2d::extension::AssetsManager *assetM = new cocos2d::extension::AssetsManager("", "", w_able_path.c_str());
        // assetM->update();
        uncompress(w_able_path.c_str(), dest_path.c_str());
        remove(dest_path.c_str());
#endif
        
    }
    

    // load framework
    pStack->setXXTEAKeyAndSign("hahaleddz", 9, "hahale", 6);
    pStack->loadChunksFromZIP("zipres/framework_precompiled.zip");
    

#if DDZ_DEBUG > 0
          CCLog("**********DDZ_DEBUG*********");
#else
          CCLog("**********DDZ_RELEASE********");
    pStack->loadChunksFromZIP("zipres/slogic.dat");
    
    pStack->setXXTEAKeyAndSign("hahaleddz", 9, "hahale", 6);
    pStack->loadChunksFromZIP("zipres/cui.zip");
#endif
    
   pStack->executeString("require 'main'");

#endif


    return true;
}
bool AppDelegate::uncompress(const char* out_path, const char* out_full_path)
{
    // Open the zip file
    string outpath = out_path;
    string zip_pwd = "hahaled";
    outpath = outpath + "/";
    CCLog("AppDelegate::uncompress, outpath= %s", outpath.c_str());
    string outFileName = out_full_path;
    unzFile zipfile = unzOpen(outFileName.c_str());
    if (! zipfile)
    {
        CCLog("can not open downloaded zip file %s", outFileName.c_str());
        return false;
    }
    
    // Get info about the zip file
    unz_global_info global_info;
    if (unzGetGlobalInfo(zipfile, &global_info) != UNZ_OK)
    {
        CCLog("can not read file global info of %s", outFileName.c_str());
        unzClose(zipfile);
        return false;
    }
    
    // Buffer to hold data read from the zip file
    char readBuffer[BUFFER_SIZE];
    
    CCLog("start uncompressing");
    
    // Loop to extract all files.
    uLong i;
    for (i = 0; i < global_info.number_entry; ++i)
    {
        // Get info about current file.
        unz_file_info fileInfo;
        char fileName[MAX_FILENAME];
        if (unzGetCurrentFileInfo(zipfile,
                                  &fileInfo,
                                  fileName,
                                  MAX_FILENAME,
                                  NULL,
                                  0,
                                  NULL,
                                  0) != UNZ_OK)
        {
            CCLog("can not read file info");
            unzClose(zipfile);
            return false;
        }
        
        string fullPath = outpath + fileName;
        CCLog("AppDelegate::uncompress, fullPath= %s", fullPath.c_str());
        // Check if this entry is a directory or a file.
        const size_t filenameLength = strlen(fileName);
        if (fileName[filenameLength-1] == '/')
        {
            // get all dir
            string fileNameStr = string(fileName);
            size_t position = 0;
            while((position=fileNameStr.find_first_of("/",position))!=string::npos)
            {
                string dirPath =outpath + fileNameStr.substr(0, position);
                CCLog("AppDelegate::uncompress, dirPath= %s", dirPath.c_str());
            // Entry is a direcotry, so create it.
            // If the directory exists, it will failed scilently.
                if (!createDirectory(dirPath.c_str()))
                {
                        CCLog("can not create directory %s", dirPath.c_str());
                        //unzClose(zipfile);
                        //return false;
                }
                position++;
            }   
        }
        else
        {
            string fileNameStr = string(fileName);
            size_t position = 0;
            while((position=fileNameStr.find_first_of("/",position))!=string::npos)
            {
                string dirPath =outpath + fileNameStr.substr(0, position);
                CCLog("AppDelegate::uncompress, dirPath= %s", dirPath.c_str());
            // Entry is a direcotry, so create it.
            // If the directory exists, it will failed scilently.
                if (!createDirectory(dirPath.c_str()))
                {
                        CCLog("can not create directory %s", dirPath.c_str());
                        //unzClose(zipfile);
                        //return false;
                }
                position++;
            } 
            // Entry is a file, so extract it.
            
            // Open current file.
            if (unzOpenCurrentFilePassword(zipfile, "hahaled") != UNZ_OK)
            {
                CCLog("can not open file %s", fileName);
                unzClose(zipfile);
                return false;
            }
            
            // Create a file to store current file.
            FILE *out = fopen(fullPath.c_str(), "wb");
            if (! out)
            {
                CCLog("can not open destination file %s", fullPath.c_str());
                unzCloseCurrentFile(zipfile);
                unzClose(zipfile);
                return false;
            }
            
            // Write current file content to destinate file.
            int error = UNZ_OK;
            do
            {
                error = unzReadCurrentFile(zipfile, readBuffer, BUFFER_SIZE);
                if (error < 0)
                {
                    CCLog("can not read zip file %s, error code is %d", fileName, error);
                    unzCloseCurrentFile(zipfile);
                    unzClose(zipfile);
                    return false;
                }
                
                if (error > 0)
                {
                    fwrite(readBuffer, error, 1, out);
                }
            } while(error > 0);
            
            fclose(out);
        }
        
        unzCloseCurrentFile(zipfile);
        
        // Goto next entry listed in the zip file.
        if ((i+1) < global_info.number_entry)
        {
            if (unzGoToNextFile(zipfile) != UNZ_OK)
            {
                CCLog("can not read next file");
                unzClose(zipfile);
                return false;
            }
        }
    }
    
    CCLog("end uncompressing");
    
    return true;
}
bool AppDelegate::IsDirExistAndCreate(const char *path) {
    mode_t processMask = umask(0);
    int ret = mkdir(path, S_IRWXU | S_IRWXG | S_IRWXO);
    umask(processMask);
    if (errno == EEXIST) {
        return true;
    }

    return false;
}

bool AppDelegate::createDirectory(const char *path) {
    mode_t processMask = umask(0);
    int ret = mkdir(path, S_IRWXU | S_IRWXG | S_IRWXO);
    umask(processMask);
    if (ret != 0 && (errno != EEXIST)) {
        return false;
    }

    return true;
}

//添加缓存目录为加载目录
void AppDelegate::setSearchPath()
{
    //CCFileUtils::sharedFileUtils()->addSearchPath("cui");
    //CCFileUtils::sharedFileUtils()->addSearchPath("cui/");
	vector<string> searchPaths = CCFileUtils::sharedFileUtils()->getSearchPaths();
    vector<string>::iterator iter = searchPaths.begin();
    std::string file_path = CCFileUtils::sharedFileUtils()->getWritablePath() + "resources/";
    CCLog("file_path => %s", file_path.c_str());
    searchPaths.insert(iter, file_path);
    CCFileUtils::sharedFileUtils()->setSearchPaths(searchPaths);


    searchPaths = CCFileUtils::sharedFileUtils()->getSearchPaths();
    iter = searchPaths.begin();
    file_path = CCFileUtils::sharedFileUtils()->getWritablePath() + "cui/";
    CCLog("file_path => %s", file_path.c_str());
    searchPaths.insert(iter, file_path);
    CCFileUtils::sharedFileUtils()->setSearchPaths(searchPaths);

    searchPaths = CCFileUtils::sharedFileUtils()->getSearchPaths();
    iter = searchPaths.begin();
    file_path = "/sdcard/fungame/ruitong/";
    CCLog("file_path => %s", file_path.c_str());
    searchPaths.insert(iter, file_path);
    CCFileUtils::sharedFileUtils()->setSearchPaths(searchPaths);
   
    searchPaths = CCFileUtils::sharedFileUtils()->getSearchPaths();
    iter = searchPaths.begin();
    file_path = "/sdcard/fungame/ruitong/cui/";
    CCLog("file_path => %s", file_path.c_str());
    searchPaths.insert(iter, file_path);
    CCFileUtils::sharedFileUtils()->setSearchPaths(searchPaths);

    // CCFileUtils:sharedFileUtils():purgeCachedEntries()

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
