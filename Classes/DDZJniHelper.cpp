#include "DDZJniHelper.h"
#include "platform/android/jni/JniHelper.h"
#include <jni.h>
#include "support/CCNotificationCenter.h"

using namespace cocos2d;
bool DDZJniHelper::is_onCppMessage = false;
bool DDZJniHelper::is_messageJava = false;
extern "C" {
void Java_com_ruitong_WZDDZ_DDZJniHelper_messageCpp(JNIEnv* env, jobject thiz,
		jstring text) {

	CCLog("[Java_com_ruitong_WZDDZ_DDZJniHelper_test] enter.");

	std::string myText = JniHelper::jstring2string(text);

	if (myText.compare("on_exit")==0) {
		CCDirector::sharedDirector()->end();
		return;
	}

	CCNotificationCenter::sharedNotificationCenter()->postNotification(myText.c_str());
	/*DDZJniHelper* h = new DDZJniHelper();
	const char* is_connected = h->get("IsNetworkConnected");*/

	CCLog("[Java_com_ruitong_WZDDZ_DDZJniHelper_test] pText: %s.", myText.c_str());

	CCLog("[Java_com_ruitong_WZDDZ_DDZJniHelper_test] return.");
}
}

void DDZJniHelper::messageJava(const char* text) {
	//CCLog("[DDZJniHelper::messageJava] text => %s", text);
	static JniMethodInfo DDZJniHelper_onCppMessage;
	if (!DDZJniHelper::is_messageJava) {
		if (!JniHelper::getStaticMethodInfo(DDZJniHelper_onCppMessage,
				"com/ruitong/WZDDZ/DDZJniHelper", "onCppMessage",
				"(Ljava/lang/String;)V"))
			return;
		CCLOG("jni on init message java");
		DDZJniHelper::is_messageJava = true;
	}

	jstring jText = DDZJniHelper_onCppMessage.env->NewStringUTF(text);

	DDZJniHelper_onCppMessage.env->CallStaticVoidMethod(
			DDZJniHelper_onCppMessage.classID,
			DDZJniHelper_onCppMessage.methodID, jText);
	DDZJniHelper_onCppMessage.env->DeleteLocalRef(jText);
}

const char* DDZJniHelper::get(const char* text) {
	std::string func_name = "get";
	func_name.append(text);
	CCLog("[DDZJniHelper::get] func_name => %s", func_name.c_str());

	// init function
	static JniMethodInfo DDZJniHelper_func_name;
	if (!DDZJniHelper::is_onCppMessage) {
		if (!JniHelper::getStaticMethodInfo(DDZJniHelper_func_name,
						"com/ruitong/WZDDZ/DDZJniHelper", "get",
						"(Ljava/lang/String;)Ljava/lang/String;"))
			return "";
		CCLOG("jni on init get");
		is_onCppMessage = true;
	}

	//run function in java
	jstring jstx = DDZJniHelper_func_name.env->NewStringUTF(text);
	jobject result = DDZJniHelper_func_name.env->CallStaticObjectMethod(
				DDZJniHelper_func_name.classID, DDZJniHelper_func_name.methodID, jstx);

	//cast object
	jstring js = (jstring) result;
	std::string myText = JniHelper::jstring2string(js);
	myText.append("\0");

	//delete refrence
	DDZJniHelper_func_name.env->DeleteLocalRef(js);
	DDZJniHelper_func_name.env->DeleteLocalRef(jstx);

	//CCLog("[DDZJniHelper::%s] result => %s, length => %d", func_name.c_str(),
	//		myText.c_str(), myText.length());
	return myText.c_str();
}

DDZJniHelper* DDZJniHelper::create() {
	DDZJniHelper* helper = new DDZJniHelper();
	return helper;
}
