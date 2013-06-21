#include "DDZJniHelper.h"
#include "platform/android/jni/JniHelper.h"
#include <jni.h>

using namespace cocos2d;

extern "C" {
void Java_com_tblin_DDZ2_DDZJniHelper_messageCpp(JNIEnv* env, jobject thiz,
		jstring text) {

	CCLog("[Java_com_tblin_DDZ2_DDZJniHelper_test] enter.");

	std::string myText = JniHelper::jstring2string(text);

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

	DDZJniHelper_onCppMessage.env->CallStaticVoidMethod(DDZJniHelper_onCppMessage.classID,
			DDZJniHelper_onCppMessage.methodID, jText);
	DDZJniHelper_onCppMessage.env->DeleteLocalRef(jText);
}
