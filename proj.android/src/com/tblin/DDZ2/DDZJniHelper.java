package com.tblin.DDZ2;

public class DDZJniHelper {
	public static native void messageCpp(String str);

	public static void onCppMessage(String str) {
		System.out.println("onCppMessage: " + str);
	}
	
	public static String getIsNetworkConnected() {
		boolean is_connected = NetworkListener.isNetworkConnected(DouDiZhuApplicaion.APP_CONTEXT);
		return String.valueOf(is_connected);
	}
}
