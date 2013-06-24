package com.tblin.DDZ2;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.telephony.TelephonyManager;

public class NetworkListener extends BroadcastReceiver {
	
	private static NetworkState last_state = null;

	@Override
	public void onReceive(Context context, Intent intent) {
		boolean is_connected = isNetworkConnected(context);
		System.out.println("on network connectivity change:" + is_connected);
		String type = getNetworkType(context);
		if (null == last_state) {
			last_state = new NetworkState();
		} else if (is_connected == last_state.is_connected) {
			System.out.println("network connected state has not change, ignore");
			last_state.type = type;
			return;
		}
		System.out.println("process network connected state change");
		last_state.is_connected = is_connected;
		last_state.type = type;
	}
	
	public static boolean isNetworkConnected(Context context) {
		ConnectivityManager cm = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
		NetworkInfo ni = cm.getActiveNetworkInfo();
		if (null == ni) return false;
		return ni.isAvailable() && ni.isConnected();
	}
	
	public static String getNetworkType(Context context) {
		ConnectivityManager cm = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
		NetworkInfo ni = cm.getActiveNetworkInfo();
		if (null == ni) return "no_network";
		String type = ni.getTypeName();
		if (type.equalsIgnoreCase("MOBILE"))
			type = type + ":" + getMobileNetworkType(context);
		return type;
	}
	
	public static String getMobileNetworkType(Context context) {
		TelephonyManager tm = (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
		int type = tm.getNetworkType();
		String ntype = "3G";
		if (1 == type || 2 == type || 4 == type)
			ntype = "2G";
		return ntype;
	}
	
	private class NetworkState {
		public boolean is_connected = false;
		public String type = "MOBILE:2G";
	}

}
