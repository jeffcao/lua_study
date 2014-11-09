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

std::string CheckSign::get_sign() {
	JniMethodInfo func_name;

	//1.获取context
	if (!JniHelper::getStaticMethodInfo(func_name,
			"com/ruitong/WZDDZ/DDZApplicaion", "getContext",
			"()Landroid/content/Context;"))
		return NULL;
	jobject j = func_name.env->CallStaticObjectMethod(func_name.classID,
			func_name.methodID);

	//2.获取包名
	if (!JniHelper::getMethodInfo(func_name, "android/content/Context",
			"getPackageName", "()Ljava/lang/String;"))
		return NULL;
	jstring pkg_name = (jstring) func_name.env->CallObjectMethod(j,
			func_name.methodID);

	//3.获取PackageManager
	if (!JniHelper::getMethodInfo(func_name, "android/content/Context",
			"getPackageManager", "()Landroid/content/pm/PackageManager;"))
		return NULL;
	jobject pm = func_name.env->CallObjectMethod(j, func_name.methodID);

	//4.获取PackageManager.GET_SIGNATURES
	jclass si_cls = func_name.env->FindClass(
			"android/content/pm/PackageManager");
	jfieldID si_flag_fd = func_name.env->GetStaticFieldID(si_cls,
			"GET_SIGNATURES", "I");
	jint flag = func_name.env->GetStaticIntField(si_cls, si_flag_fd);

	//5.获取PackageInfo
	if (!JniHelper::getMethodInfo(func_name,
			"android/content/pm/PackageManager", "getPackageInfo",
			"(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;"))
		return NULL;
	jobject pi = func_name.env->CallObjectMethod(pm, func_name.methodID,
			pkg_name, flag);

	//6.获取Signature
	jclass cls = func_name.env->GetObjectClass(pi);
	jfieldID fid = func_name.env->GetFieldID(cls, "signatures",
			"[Landroid/content/pm/Signature;");
	jobjectArray arr = (jobjectArray) func_name.env->GetObjectField(pi, fid);
	jobject obj = func_name.env->GetObjectArrayElement(arr, 0);

	//7.将Signature转换为jstring,然后转换为const char*
	if (!JniHelper::getMethodInfo(func_name, "android/content/pm/Signature",
			"toCharsString", "()Ljava/lang/String;"))
		return NULL;
	jstring str = (jstring) func_name.env->CallObjectMethod(obj,
			func_name.methodID);
	std::string std_str = JniHelper::jstring2string(str);
	//CCLOG("std_str is %s", std_str.c_str());

	func_name.env->DeleteLocalRef(str);
	func_name.env->DeleteLocalRef(obj);
	func_name.env->DeleteLocalRef(arr);
	func_name.env->DeleteLocalRef(pi);
	func_name.env->DeleteLocalRef(pm);
	func_name.env->DeleteLocalRef(j);
	func_name.env->DeleteLocalRef(pkg_name);
	return std_str;
}

const char* CheckSign::check_sign(const char* s_name, const char* s_code) {
	string st_name = string(s_name);
	string st_sign = CheckSign::get_sign();
	//CCLOG("st_sign is %s", st_sign.c_str());
	string st_code = string(s_code);

	//CCLOG("ii_code %d", ii_code);
	//合并出字符串
	string str = st_name + st_sign + st_code;

	//CCLOG("str is %s", str.c_str());

	//计算MD5
	MD5* md5 = MD5::create();
	md5->update(str);
	const char* m_md5 = md5->to_char_array();
	return m_md5;
}
