package cn.com.m123.DDZ.push;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class PushReceiver extends BroadcastReceiver {
	

	/**
	 * <intent-filter >
     *    <action android:name="android.intent.action.PACKAGE_RESTARTED"/>
     *    <data android:scheme="package"></data>
     * </intent-filter>
     * #packageName + ".fetch_alarm"
     * <intent-filter>
     *    <action android:name="cn.com.m123.DDZ.fetch_alarm"/>
     * </intent-filter>
     * #packageName + ".push_alarm"
     * <intent-filter>
     *    <action android:name="cn.com.m123.DDZ.push_alarm"/>
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
		if (null != intent && null != intent.getAction()) {
			service_intent.setAction(intent.getAction());
		}
		context.startService(service_intent);
	}

}
