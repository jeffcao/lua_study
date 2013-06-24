#include "DDZJniHelper.h"
#include "platform/android/jni/JniHelper.h"
#include <jni.h>

using namespace cocos2d;

extern "C" {
void Java_com_tblin_DDZ2_DDZJniHelper_messageCpp(JNIEnv* env, jobject thiz,
		jstring text) {

	CCLog("[Java_com_tblin_DDZ2_DDZJniHelper_test] enter.");

	std::string myText = JniHelper::jstring2string(text);

	/*DDZJniHelper* h = new DDZJniHelper();
	const char* is_connected = h->get("IsNetworkConnected");*/

	CCLog("[Java_com_tblin_DDZ2_DDZJniHelper_test] pText: %s.", myText.c_str());

	CCLog("[Java_com_tblin_DDZ2_DDZJniHelper_test] return.");
}
}

void DDZJniHelper::messageJava(const char* text) {
	CCLog("[DDZJniHelper::messageJava] text => %s", text);
	static JniMethodInfo DDZJniHelper_onCppMessage;
	static bool DDZJniHelper_onCppMessage_init = false;
	if (!DDZJniHelper_onCppMessage_init) {
		if (!JniHelper::getStaticMethodInfo(DDZJniHelper_onCppMessage,
				"com/tblin/DDZ2/DDZJniHelper", "onCppMessage",
				"(Ljava/lang/String;)V"))
			return;
		DDZJniHelper_onCppMessage_init = true;
	}

	jstring jText = DDZJniHelper_onCppMessage.env->NewStringUTF(text);

	DDZJniHelper_onCppMessage.env->CallStaticVoidMethod(
			DDZJniHelper_onCppMessage.classID,
			DDZJniHelper_onCppMessage.methodID, jText);
	DDZJniHelper_onCppMessage.env->DeleteLocalRef(jText);
}

const char* DDZJniHelper::get(const char* text) {
	std::string* func_name = new std::string("get");
	func_name->append(text);
	CCLog("[DDZJniHelper::get] func_name => %s", func_name->c_str());

	// init function
	static JniMethodInfo DDZJniHelper_func_name;
	static bool DDZJniHelper_func_name_init = false;
	if (!DDZJniHelper_func_name_init) {
		if (!JniHelper::getStaticMethodInfo(DDZJniHelper_func_name,
						"com/tblin/DDZ2/DDZJniHelper", "get",
						"(Ljava/lang/String;)Ljava/lang/String;"))
			return "";
		DDZJniHelper_func_name_init = true;
	}

	//run function in java
	jstring jstx = DDZJniHelper_func_name.env->NewStringUTF(text);
	jobject result = DDZJniHelper_func_name.env->CallStaticObjectMethod(
				DDZJniHelper_func_name.classID, DDZJniHelper_func_name.methodID, jstx);

	//cast object
	jstring js = (jstring) result;
	std::string myText = JniHelper::jstring2string(js);

	//delete refrence
	DDZJniHelper_func_name.env->DeleteLocalRef(js);
	DDZJniHelper_func_name.env->DeleteLocalRef(jstx);

	CCLog("[DDZJniHelper::%s] result => %s", func_name->c_str(),
			myText.c_str());
	return myText.c_str();
}
