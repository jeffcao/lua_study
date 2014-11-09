#ifndef _CHECK_SIGN_H_
#define _CHECK_SIGN_H_
#include <string>
class CheckSign {
public:
	static const char* check_sign(const char* s_name, const char* s_code);
	static std::string get_sign();
};

#endif
