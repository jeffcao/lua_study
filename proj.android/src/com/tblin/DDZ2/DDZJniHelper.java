package com.tblin.DDZ2;

public class DDZJniHelper {
	public static native void messageCpp(String str);

	public static void onCppMessage(String str) {
		System.out.println("onCppMessage: " + str);
	}
	
	public static String get(String func_name) {
		System.out.println("func_name is: " + func_name);
		if (func_name.equals("IsNetworkConnected")) {
			return getIsNetworkConnected();
		}
		return "";
	}
	
	public static String getIsNetworkConnected() {
		boolean is_connected = NetworkListener.isNetworkConnected(DouDiZhuApplicaion.APP_CONTEXT);
		return String.valueOf(is_connected);
	}
}
