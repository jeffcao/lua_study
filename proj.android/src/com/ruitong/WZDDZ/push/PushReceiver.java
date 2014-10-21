package com.ruitong.WZDDZ.push;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import com.ruitong.WZDDZ.test.Logger;

public class PushReceiver extends BroadcastReceiver {
	private static final String tag = PushReceiver.class.getName();

	/**
	 * <intent-filter >
     *    <action android:name="android.intent.action.PACKAGE_RESTARTED"/>
     *    <data android:scheme="package"></data>
     * </intent-filter>
     * #packageName + ".fetch_alarm"
     * <intent-filter>
     *    <action android:name="com.ruitong.WZDDZ.fetch_alarm"/>
     * </intent-filter>
     * #packageName + ".push_alarm"
     * <intent-filter>
     *    <action android:name="com.ruitong.WZDDZ.push_alarm"/>
     * </intent-filter>
     * <intent-filter>
     *    <action android:name="android.intent.action.BOOT_COMPLETED"></action>
     * </intent-filter>
     * <intent-filter>   
     *    <action android:name="android.net.conn.CONNECTIVITY_CHANGE"/>   
     * </intent-filter>
	 */
	@Override
	public void onReceive(Context context, Intent intent) {
		Intent service_intent = new Intent(context, PushService.class);
		String action = null != intent ? intent.getAction() : null;
		if (null != action) {
			Logger.i(tag, "is action null? " + (null == action));
			Logger.i(tag, "on receive action " + action
					+ "\n  at time:" + PushTask.transTime(System.currentTimeMillis()));
			service_intent.setAction(action);
		}
		context.startService(service_intent);
	}

}
