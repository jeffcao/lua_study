/****************************************************************************
 Copyright (c) 2013 cocos2d-x.org
 
 http://www.cocos2d-x.org
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

#include "Downloader.h"
#include "cocos2d.h"

#include <curl/curl.h>
#include <curl/easy.h>
#include <stdio.h>
#include <vector>

#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#endif

#include "support/zip_support/unzip.h"

using namespace cocos2d;
using namespace std;

#define TEMP_PACKAGE_FILE_NAME    "cocos2dx-update-temp-package.zip"
#define BUFFER_SIZE    8192
#define MAX_FILENAME   512

// Message type
#define DOWNLOADER_MESSAGE_UPDATE_SUCCEED                0
#define DOWNLOADER_MESSAGE_PROGRESS                      2
#define DOWNLOADER_MESSAGE_ERROR                         3

// Some data struct for sending messages

struct ErrorMessage
{
    Downloader::ErrorCode code;
    Downloader* manager;
};

struct ProgressMessage
{
    int percent;
    Downloader* manager;
};

// Implementation of Downloader

Downloader::Downloader(const char* url/* =NULL */, const char* storagePath/* =NULL */, const char* name/* = NULL */)
:  _storagePath(storagePath)
, _url(url)
, _name(name)
, _curl(NULL)
, _tid(NULL)
, _connectionTimeout(0)
, _delegate(NULL)
{
    checkStoragePath();
    _schedule = new Helper();
}

Downloader::~Downloader()
{
    if (_schedule)
    {
        _schedule->release();
    }
}

void Downloader::checkStoragePath()
{
    if (_storagePath.size() > 0 && _storagePath[_storagePath.size() - 1] != '/')
    {
        _storagePath.append("/");
    }
}

void* downloaderDownloadAndUncompress(void *data)
{
    Downloader* self = (Downloader*)data;
    
    do
    {
        if (! self->downLoad()) break;

        //do not auto uncompress
        /*// Uncompress zip file.
        if (! self->uncompress())
        {
            self->sendErrorMessage(Downloader::kUncompress);
            break;
        }*/
        
        // Record updated version and remove downloaded zip file
        Downloader::Message *msg2 = new Downloader::Message();
        msg2->what = DOWNLOADER_MESSAGE_UPDATE_SUCCEED;
        msg2->obj = self;
        self->_schedule->sendMessage(msg2);
    } while (0);
    
    if (self->_tid)
    {
        delete self->_tid;
        self->_tid = NULL;
    }
    
    return NULL;
}

void Downloader::update()
{
    if (_tid) return;
    
    // 1. Urls of package and version should be valid;
    // 2. Package should be a zip file.
    /**
    if (_url.size() == 0 ||
        std::string::npos == _url.find(".zip"))
    {
        CCLOG("no url, or the package is not a zip file");
        return;
    }
    */
    if (_url.size() == 0) {
    	CCLOG("no url");
    	return;
    }
    
    _tid = new pthread_t();
    pthread_create(&(*_tid), NULL, downloaderDownloadAndUncompress, this);
}

bool Downloader::uncompress()
{
    // Open the zip file
    string outFileName = _storagePath + TEMP_PACKAGE_FILE_NAME;
    if (_name.c_str()) {
    	outFileName = _storagePath + _name;
    }
    unzFile zipfile = unzOpen(outFileName.c_str());
    /*
    if (! zipfile)
    {
        CCLOG("can not open downloaded zip file %s", outFileName.c_str());
        return false;
    }
    */

    if (! zipfile) {
    	CCLOG("is not zip file");
    	return true;
    }
    
    // Get info about the zip file
    unz_global_info global_info;
    if (unzGetGlobalInfo(zipfile, &global_info) != UNZ_OK)
    {
        CCLOG("can not read file global info of %s", outFileName.c_str());
        unzClose(zipfile);
        return false;
    }
    
    // Buffer to hold data read from the zip file
    char readBuffer[BUFFER_SIZE];
    
    CCLOG("start uncompressing");
    
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
            CCLOG("can not read file info");
            unzClose(zipfile);
            return false;
        }
        
        string fullPath = _storagePath + fileName;
        
        // Check if this entry is a directory or a file.
        const size_t filenameLength = strlen(fileName);
        if (fileName[filenameLength-1] == '/')
        {
            // Entry is a direcotry, so create it.
            // If the directory exists, it will failed scilently.
            if (!createDirectory(fullPath.c_str()))
            {
                CCLOG("can not create directory %s", fullPath.c_str());
                unzClose(zipfile);
                return false;
            }
        }
        else
        {
            // Entry is a file, so extract it.
            
            // Open current file.
            if (unzOpenCurrentFile(zipfile) != UNZ_OK)
            {
                CCLOG("can not open file %s", fileName);
                unzClose(zipfile);
                return false;
            }
            
            // Create a file to store current file.
            FILE *out = fopen(fullPath.c_str(), "wb");
            if (! out)
            {
                CCLOG("can not open destination file %s", fullPath.c_str());
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
                    CCLOG("can not read zip file %s, error code is %d", fileName, error);
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
                CCLOG("can not read next file");
                unzClose(zipfile);
                return false;
            }
        }
    }
    
    CCLOG("end uncompressing");
    
    return true;
}

/*
 * Create a direcotry is platform depended.
 */
bool Downloader::createDirectory(const char *path)
{
#if (CC_TARGET_PLATFORM != CC_PLATFORM_WIN32)
    mode_t processMask = umask(0);
    int ret = mkdir(path, S_IRWXU | S_IRWXG | S_IRWXO);
    umask(processMask);
    if (ret != 0 && (errno != EEXIST))
    {
        return false;
    }
    
    return true;
#else
    BOOL ret = CreateDirectoryA(path, NULL);
	if (!ret && ERROR_ALREADY_EXISTS != GetLastError())
	{
		return false;
	}
    return true;
#endif
}

void Downloader::setSearchPath()
{
    vector<string> searchPaths = CCFileUtils::sharedFileUtils()->getSearchPaths();
    vector<string>::iterator iter = searchPaths.begin();
    searchPaths.insert(iter, _storagePath);
    CCFileUtils::sharedFileUtils()->setSearchPaths(searchPaths);
}

static size_t downLoadPackage(void *ptr, size_t size, size_t nmemb, void *userdata)
{
    FILE *fp = (FILE*)userdata;
    size_t written = fwrite(ptr, size, nmemb, fp);
    return written;
}

int downloadProgressFunc(void *ptr, double totalToDownload, double nowDownloaded, double totalToUpLoad, double nowUpLoaded)
{
    Downloader* manager = (Downloader*)ptr;
    Downloader::Message *msg = new Downloader::Message();
    msg->what = DOWNLOADER_MESSAGE_PROGRESS;
    
    ProgressMessage *progressData = new ProgressMessage();
    progressData->percent = (int)(nowDownloaded/totalToDownload*100);
    progressData->manager = manager;
    msg->obj = progressData;
    
    manager->_schedule->sendMessage(msg);
    
    CCLOG("downloading... %d%%", (int)(nowDownloaded/totalToDownload*100));
    
    return 0;
}

bool Downloader::downLoad()
{
    // Create a file to save package.
    string outFileName = _storagePath + TEMP_PACKAGE_FILE_NAME;
    if (_name.c_str()) {
        	outFileName = _storagePath + _name;
    }
    FILE *fp = fopen(outFileName.c_str(), "wb");
    if (! fp)
    {
        sendErrorMessage(kCreateFile);
        CCLOG("can not create file %s", outFileName.c_str());
        return false;
    }
    
    // Download pacakge
    CURLcode res;
    CCLOG("curl url is %s", _url.c_str());
    if (!_curl)
    	_curl = curl_easy_init();
    curl_easy_setopt(_curl, CURLOPT_URL, _url.c_str());
    curl_easy_setopt(_curl, CURLOPT_WRITEFUNCTION, downLoadPackage);
    curl_easy_setopt(_curl, CURLOPT_WRITEDATA, fp);
    curl_easy_setopt(_curl, CURLOPT_NOPROGRESS, false);
    curl_easy_setopt(_curl, CURLOPT_PROGRESSFUNCTION, downloadProgressFunc);
    curl_easy_setopt(_curl, CURLOPT_PROGRESSDATA, this);
    res = curl_easy_perform(_curl);
    curl_easy_cleanup(_curl);
    if (res != 0)
    {
        sendErrorMessage(kNetwork);
        CCLOG("error when download package");
        fclose(fp);
        return false;
    }
    
    CCLOG("succeed downloading package %s", _url.c_str());
    
    fclose(fp);
    return true;
}

const char* Downloader::getUrl() const
{
    return _url.c_str();
}

void Downloader::setUrl(const char *url)
{
    _url = url;
}

const char* Downloader::getName() const
{
    return _name.c_str();
}

void Downloader::setName(const char *name)
{
	_name = name;
}

const char* Downloader::getStoragePath() const
{
    return _storagePath.c_str();
}

void Downloader::setStoragePath(const char *storagePath)
{
    _storagePath = storagePath;
    checkStoragePath();
}

void Downloader::setDelegate(DownloaderDelegateProtocol *delegate)
{
    _delegate = delegate;
}

void Downloader::setConnectionTimeout(unsigned int timeout)
{
    _connectionTimeout = timeout;
}

unsigned int Downloader::getConnectionTimeout()
{
    return _connectionTimeout;
}

void Downloader::sendErrorMessage(Downloader::ErrorCode code)
{
    Message *msg = new Message();
    msg->what = DOWNLOADER_MESSAGE_ERROR;
    
    ErrorMessage *errorMessage = new ErrorMessage();
    errorMessage->code = code;
    errorMessage->manager = this;
    msg->obj = errorMessage;
    
    _schedule->sendMessage(msg);
}

// Implementation of DownloaderHelper

Downloader::Helper::Helper()
{
    _messageQueue = new list<Message*>();
    pthread_mutex_init(&_messageQueueMutex, NULL);
    CCDirector::sharedDirector()->getScheduler()->scheduleUpdateForTarget(this, 0, false);
}

Downloader::Helper::~Helper()
{
    CCDirector::sharedDirector()->getScheduler()->unscheduleAllForTarget(this);
    delete _messageQueue;
}

void Downloader::Helper::sendMessage(Message *msg)
{
    pthread_mutex_lock(&_messageQueueMutex);
    _messageQueue->push_back(msg);
    pthread_mutex_unlock(&_messageQueueMutex);
}

void Downloader::Helper::update(float dt)
{
    Message *msg = NULL;
    
    // Returns quickly if no message
    pthread_mutex_lock(&_messageQueueMutex);
    if (0 == _messageQueue->size())
    {
        pthread_mutex_unlock(&_messageQueueMutex);
        return;
    }
    
    // Gets message
    msg = *(_messageQueue->begin());
    _messageQueue->pop_front();
    pthread_mutex_unlock(&_messageQueueMutex);
    
    switch (msg->what) {
        case DOWNLOADER_MESSAGE_UPDATE_SUCCEED:
            handleUpdateSucceed(msg);
            break;
        case DOWNLOADER_MESSAGE_PROGRESS:
            if (((ProgressMessage*)msg->obj)->manager->_delegate)
            {
                ((ProgressMessage*)msg->obj)->manager->_delegate->onProgress(((ProgressMessage*)msg->obj)->percent);
            }
            
            delete (ProgressMessage*)msg->obj;
            
            break;
        case DOWNLOADER_MESSAGE_ERROR:
            // error call back
            if (((ErrorMessage*)msg->obj)->manager->_delegate)
            {
                ((ErrorMessage*)msg->obj)->manager->_delegate->onError(((ErrorMessage*)msg->obj)->code);
            }
            
            delete ((ErrorMessage*)msg->obj);
            
            break;
        default:
            break;
    }
    
    delete msg;
}

void Downloader::Helper::handleUpdateSucceed(Message *msg)
{
    Downloader* manager = (Downloader*)msg->obj;
    
    // Set resource search path.
    manager->setSearchPath();
    
    // Delete unloaded zip file.
    string zipfileName = manager->_storagePath + TEMP_PACKAGE_FILE_NAME;
    if (manager->_name.c_str()) {
    	zipfileName = manager->_storagePath + manager->_name;
    }
    if (remove(zipfileName.c_str()) != 0)
    {
        CCLOG("can not remove downloaded zip file %s", zipfileName.c_str());
    }
    
    if (manager) manager->_delegate->onSuccess();
}
