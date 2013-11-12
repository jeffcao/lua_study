#include "CheckSign.h"
#include <string>
#include <cstdlib>
#include <math.h>
#include <md5.h>
#include "cocos2d.h"

using namespace std;

const char* CheckSign::check_sign(const char* s_name, const char* s_sign,
		const char* s_code, const char* i_code) {
	string st_name = string(s_name);
	string st_sign = string(s_sign);
	string st_code = string(s_code);
	string it_code = string(i_code);

	//计算出需要截取多少位
	int i_code_len = it_code.length();
	string count = it_code.substr(i_code_len - 2, 2);
	int i_count = atoi(count.c_str());
	string st_code_jq = st_code.substr(0, i_count);

	//计算出合并方式
	string code = it_code.substr(0, i_code_len - 2);
	int ii_code = atoi(code.c_str()) / i_count;
	string codes[4] = {st_name, st_sign, st_code, st_code_jq};

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
		str += codes[index-1];
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
