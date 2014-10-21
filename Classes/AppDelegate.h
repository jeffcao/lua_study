#ifndef  _APP_DELEGATE_H_
#define  _APP_DELEGATE_H_

#include "CCApplication.h"
#include <string>
#include "ProjectConfig/SimulatorConfig.h"
//#include "Downloader.h"

/**
@brief    The cocos2d Application.

The reason for implement as private inheritance is to hide some interface call by CCDirector.
*/
class  AppDelegate : private cocos2d::CCApplication
{
public:
    AppDelegate();
    virtual ~AppDelegate();

    /**
    @brief    Implement CCDirector and CCScene init code here.
    @return true    Initialize success, app continue.
    @return false   Initialize failed, app terminate.
    */
    virtual bool applicationDidFinishLaunching();

    /**
    @brief  The function be called when the application enter background
    @param  the pointer of the application
    */
    virtual void applicationDidEnterBackground();

    /**
    @brief  The function be called when the application enter foreground
    @param  the pointer of the application
    */
    virtual void applicationWillEnterForeground();

    void setSearchPath();

    void StringReplace(std::string &strBase, std::string strSrc, std::string strDes);

    void setProjectConfig(const ProjectConfig& config);

private:
    ProjectConfig m_projectConfig;
    bool uncompress(const char* out_path, const char* out_full_path);
    bool createDirectory(const char *path);
};

/*class DownloadListener : public DownloaderDelegateProtocol {
public:
    virtual void onError(Downloader::ErrorCode errorCode);
    virtual void onProgress(int percent);
    virtual void onSuccess();
};*/

#endif // _APP_DELEGATE_H_

