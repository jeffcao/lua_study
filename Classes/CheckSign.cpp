#include "CheckSign.h"
#include <string>
#include <cstdlib>
#include <math.h>
#include <md5.h>
#include "cocos2d.h"
#include "platform/android/jni/JniHelper.h"
#include <jni.h>

using namespace std;
using namespace cocos2d;

const char* CheckSign::get_sign() {

	static JniMethodInfo func_name;
	//static bool func_name_init = false;
	//if (!func_name_init) {
	CCLOG("checksign ----------------------1");
		if (!JniHelper::getStaticMethodInfo(func_name,
						"cn/com/m123/DDZ/DouDiZhuApplicaion", "getContext",
						"()Landroid/content/Context;"))
			return NULL;
	//		func_name_init = true;
	//}
		CCLOG("checksign ----------------------2");
	jobject j = func_name.env->CallStaticObjectMethod(
			func_name.classID,
			func_name.methodID);
	CCLOG("checksign ----------------------3");
	if (!JniHelper::getMethodInfo(func_name, "android/content/Context", "getPackageManager", "()Landroid/content/pm/PackageManager;"))
		return NULL;
	CCLOG("checksign ----------------------4");
	jobject pm = func_name.env->CallObjectMethod(j, func_name.methodID);
	CCLOG("checksign ----------------------5");
	if (!JniHelper::getMethodInfo(func_name, "android/content/pm/PackageManager", "getPackageInfo", "(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;"))
			return NULL;
	CCLOG("checksign ----------------------6");
	jint flag = 64;
	CCLOG("checksign ----------------------6.1");
	jstring pkg_name = func_name.env->NewStringUTF("cn.com.m123.DDZ");
	CCLOG("checksign ----------------------6.2");
	jobject pi = func_name.env->CallObjectMethod(pm, func_name.methodID, pkg_name, flag);
	CCLOG("checksign ----------------------7");
	jclass cls = func_name.env->GetObjectClass(pi);
	CCLOG("checksign ----------------------7.1");
	jfieldID fid = func_name.env->GetFieldID(cls, "signatures", "[Landroid/content/pm/Signature;");
	CCLOG("checksign ----------------------7.2");
	jobjectArray arr = (jobjectArray)func_name.env->GetObjectField(pi, fid);
	CCLOG("checksign ----------------------7.3");
	jobject obj = func_name.env->GetObjectArrayElement(arr, 0);
	CCLOG("checksign ----------------------7.4");
	if (!JniHelper::getMethodInfo(func_name, "android/content/pm/Signature", "toCharsString", "()Ljava/lang/String;"))
			return NULL;
	CCLOG("checksign ----------------------7.5");
	jstring str = (jstring)func_name.env->CallObjectMethod(obj, func_name.methodID);
	CCLOG("checksign ----------------------7.6");
	std::string std_str = JniHelper::jstring2string(str);
	CCLOG("std_str is %s", std_str.c_str());
	CCLOG("checksign ----------------------8");
	/*String si = context.getPackageManager().getPackageInfo(
					context.getPackageName(), PackageManager.GET_SIGNATURES).signatures[0]
					.toCharsString();*/
	cocos2d::CCDirector* director = CCDirector::sharedDirector();
	return string("").c_str();
}

const char* CheckSign::check_sign(const char* s_name, const char* s_sign,
		const char* s_code, const char* i_code) {

	CheckSign::get_sign();

	string st_name = string(s_name);
	string st_sign = string(s_sign);
	string st_code = string(s_code);
	string it_code = string(i_code);

	//计算出需要截取多少位
	int i_code_len = it_code.length();
	string count = it_code.substr(i_code_len - 2, 2);
	int i_count = atoi(count.c_str());
	CCLOG("i_count %d", i_count);
	string st_code_jq = st_code.substr(0, i_count);

	//计算出合并方式
	string code = it_code.substr(0, i_code_len - 2);
	int ii_code = atoi(code.c_str()) / i_count;
	string codes[4] = { st_name, st_sign, st_code, st_code_jq };

	CCLOG("ii_code %d", ii_code);
	//合并出字符串
	string str = "";
	for (int i = 3; i >= 0; i--) {
		int k = pow(10, i);
		int index = ii_code / k;
		CCLOG("index %d", index);
		if (index < 0 || index > 4) {
			return "";
		}
		str += codes[index - 1];
		ii_code = ii_code % k;
		CCLOG("ii_code %d", ii_code);
	}
	CCLOG("str is %s", str.c_str());

	//计算MD5
	MD5* md5 = MD5::create();
	md5->update(str);
	const char* m_md5 = md5->to_char_array();
	return m_md5;
}
