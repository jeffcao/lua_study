package com.tblin.DDZ2;

import org.cocos2dx.lib.Cocos2dxGLSurfaceView;

public class DDZJniHelper {
	
	public static void messageToCpp(final String str) {
		Runnable r = new Runnable() {
			
			@Override
			public void run() {
				messageCpp(str);
			}
		};
		Cocos2dxGLSurfaceView.getInstance().queueEvent(r);
	}
	
	public static native void messageCpp(String str);

	public static void onCppMessage(String str) {
		System.out.println("onCppMessage: " + str);
		if (str.equals("on_set_network_intent")) {
			SysIntentSender.goNetworkSetting(DouDiZhuApplicaion.APP_CONTEXT);
		}
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
