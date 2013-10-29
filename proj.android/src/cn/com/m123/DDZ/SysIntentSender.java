package cn.com.m123.DDZ;


import java.io.File;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;

public class SysIntentSender {

	public static void createShortcut(Context context, Intent it, int o,
			int name) {
		Log.i("SysIntentSender","创建快捷方式");
		Intent intent = new Intent(
				"com.android.launcher.action.INSTALL_SHORTCUT");
		intent.putExtra("duplicate", false);
		intent.putExtra(Intent.EXTRA_SHORTCUT_INTENT, it);
		intent.putExtra(Intent.EXTRA_SHORTCUT_NAME,
				context.getString(R.string.app_name));
		intent.putExtra(Intent.EXTRA_SHORTCUT_ICON_RESOURCE,
				Intent.ShortcutIconResource.fromContext(context, o));
		context.sendBroadcast(intent);
	}

	/**
	 * <uses-permission Android:name="android.permission.CALL_PHONE" />
	 * 
	 * @param mobile
	 * @param context
	 */
	public static void call(String mobile, Context context) {
		Intent intent = new Intent(Intent.ACTION_CALL);
		String data = "tel:" + mobile;
		intent.setData(Uri.parse(data));
		context.startActivity(intent);
	}

	/**
	 * <uses-permission android:name="android.permission.SEND_SMS"/>
	 * 
	 * @param mobile
	 * @param context
	 * @param msg
	 */
	public static void sendSms(String mobile, Context context, String msg) {
		Uri smsToUri = Uri.parse("smsto:" + mobile);
		Intent sendIntent = new Intent(Intent.ACTION_VIEW, smsToUri);
		if (msg != null)
			sendIntent.putExtra("sms_body", msg);
		sendIntent.setType("vnd.android-dir/mms-sms");
		sendIntent.putExtra("address", mobile);
		context.startActivity(sendIntent);
	}

	/***
	 * android.permission.INTERNET
	 * 
	 * @param url
	 * @param context
	 */
	public static void openUrl(String url, Context context) {
		Uri uri = Uri.parse(url);
		Intent it = new Intent(Intent.ACTION_VIEW, uri);
		it.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		it.setClassName("com.android.browser","com.android.browser.BrowserActivity"); 
		context.startActivity(it);
	}
	
	public static void toHome(Context context) {
		Intent home = new Intent(Intent.ACTION_MAIN);  
	    home.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);  
	    home.addCategory(Intent.CATEGORY_HOME);  
	    context.startActivity(home);
	}

	/**
	 * android.permission.ACCESS_NETWORK_STATE
	 * 
	 * @param context
	 */
	public static void goNetworkSetting(Context context) {
		String action = null;
		if(android.os.Build.VERSION.SDK_INT > 10 ){
		     //3.0以上打开设置界面，也可以直接用ACTION_WIRELESS_SETTINGS打开到wifi界面
			action = android.provider.Settings.ACTION_SETTINGS;
		} else {
			action = android.provider.Settings.ACTION_WIRELESS_SETTINGS;
		}
		Intent it = new Intent(action);
		it.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		context.startActivity(it);
	}
	
	public static void install(Context context, String path) {
		Intent intent = new Intent(Intent.ACTION_VIEW); 
		intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		intent.setDataAndType(Uri.fromFile(new File(path)),  
		        "application/vnd.android.package-archive");  
		context.startActivity(intent);
	}
}
