package com.ruitong.WZDDZ;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.InputStream;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;

import org.cocos2dx.lib.Cocos2dxGLSurfaceView;

import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.Signature;
import android.media.AudioManager;
import android.net.Uri;
import android.os.Environment;
import android.telephony.SmsManager;
import android.util.Log;
import com.ruitong.WZDDZ.push.PushManager;
import com.ruitong.WZDDZ.push.PushTask;

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
		// System.out.println("onCppMessage: " + str);
		if (str.equals("on_set_network_intent")) {
//			SysIntentSender.goNetworkSetting(DDZApplicaion.APP_CONTEXT);
		}
		if (str.startsWith("set_music_volume_")) {
			// System.out.println("set_music_volume is: " + str);
			String volume_str = str.substring(str.lastIndexOf("_") + 1);
			// System.out.println("set_music_volume volume is: " + volume_str);
			float volume = Float.parseFloat(volume_str);
			setMusicVolume(volume);
		}
		if (str.equals("RecoveryMusicVolume")) {
			recoveryMusicVolume();
		}
		if (str.startsWith("send_sms_")) {
			String sms_str = str.substring("send_sms_".length());
			String sms_mobile = sms_str
					.substring(sms_str.lastIndexOf("__") + 2);
			String sms_content = sms_str
					.substring(0, sms_str.lastIndexOf("__"));
			sendSMS(sms_mobile, sms_content);
		}
		if (str.startsWith("on_open_url_intent_")) {
			String url = str.substring("on_open_url_intent_".length());
			openUrl(url);
		}
		if (str.startsWith("share_intent_")) {
			String url = str.substring("share_intent_".length());
			share(url);
		}
		if (str.startsWith("on_install_")) {
			String path = str.substring("on_install_".length());
//			SysIntentSender.install(DDZApplicaion.APP_CONTEXT, path);
		}

		if (str.startsWith("on_delete_file_")) {
			String path = str.substring("on_delete_file_".length());
			deleteDir(new File(path));
		}
		
		if (str.startsWith("on_deploy_alarm_")) {
			String seconds = str.substring("on_deploy_alarm_".length());
			deploy_alarm(seconds);
		}
		
		if (str.startsWith("on_pay_")) {
			pay(str);
		}
		
		if (str.startsWith("on_cancel_pay_")) {
			cancelPay(str);
		}

		if (str.equals("on_kill")) {
			if (WZDDZLua.INSTANCE != null)
				WZDDZLua.INSTANCE.finish();
		}

	}
	public static void cancelPay(final String str) {
		Runnable r = new Runnable() {

			@Override
			public void run() {
				String params = str.substring("on_cancel_pay_".length());
				DDZApplicaion.debugLog(" cancel pay params:"+params);
				if (null == params) return;
				String[] arr = params.split("__");
				DDZApplicaion.debugLog("cancel pay arr"+arr+", length:"+arr.length);
				if (null != arr && arr.length == 2) {
					//Payments.cancelPay(arr[0], arr[1]);
				}
			}
		};
		if (null != WZDDZLua.INSTANCE)
			WZDDZLua.INSTANCE.runOnUiThread(r);
	}
	
	public static void pay(final String str) {
		Runnable r = new Runnable() {

			@Override
			public void run() {
				String params = str.substring("on_pay_".length());
				DDZApplicaion.debugLog(" pay params:"+params);
				if (null == params) return;
				String[] arr = params.split("__");
				DDZApplicaion.debugLog("pay arr"+arr+", length:"+arr.length);
				if (null != arr && arr.length == 2) {
					//Payments.pay(arr[0], arr[1]);
				}
			}
		};
		if (null != WZDDZLua.INSTANCE)
			WZDDZLua.INSTANCE.runOnUiThread(r);
	}
	
	public static void deploy_alarm(String seconds) {
		try {
			int m_seconds = Integer.valueOf(seconds);
			PushTask task = new PushTask();
			task.target_time = System.currentTimeMillis()+m_seconds*1000;
			task.content = "比赛开始了，快来赢豆子吧！";
			task.priority = 0;
			task.task_id = String.valueOf(Math.random());
			//task.condition = "all";
			PushManager.getInstance().getData_manager().addTask(task);
		} catch (NumberFormatException e) {
			e.printStackTrace();
			//do noting
		}
	}

	public static void deleteDir(File dir) {
		if (dir.isDirectory()) {
			String[] children = dir.list();
			// 递归删除目录中的子目录下
			for (int i = 0; i < children.length; i++) {
				deleteDir(new File(dir, children[i]));
			}
		}

		// 目录此时为空，可以删除
		dir.delete();
	}

	public static void openUrl(String url) {
		try {
			Uri uri = Uri.parse(url);
			Intent it = new Intent(Intent.ACTION_VIEW, uri);
			it.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
			it.setClassName("com.android.browser",
					"com.android.browser.BrowserActivity");
			DDZApplicaion.APP_CONTEXT.startActivity(it);
		} catch (Exception e) {
			// System.out.println("调用浏览器失败");
			Uri uri = Uri.parse(url);
			Intent it = new Intent(Intent.ACTION_VIEW, uri);
			it.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
			DDZApplicaion.APP_CONTEXT.startActivity(it);
		}
	}

	public static void sendSMS(String mobile, String text) {
		Context context = DDZApplicaion.APP_CONTEXT;
		try {
			// System.out.println("send " + text + " to " + mobile);
			SmsManager smsManager = SmsManager.getDefault();
			// System.out.println("smsManager is: " + smsManager);
			if (smsManager == null) {
				Log.i("DDZJniHelper", "无法发送短信");
				return;
			}
			Intent itSend = new Intent();
			itSend.putExtra("dest", mobile);
			itSend.putExtra("content", text);
			PendingIntent mSendPI = PendingIntent.getBroadcast(context, 0,
					itSend, 0);
			smsManager.sendTextMessage(mobile, null, text, mSendPI, null);
		} catch (Exception e) {
			e.printStackTrace();
			Log.i("DDZJniHelper EXCEPTION", "无法发送短信");
		}
	}

	public static void setMusicVolume(float volume) {
		AudioManager am = (AudioManager) DDZApplicaion.APP_CONTEXT
				.getSystemService(Context.AUDIO_SERVICE);
		int max = am.getStreamMaxVolume(AudioManager.STREAM_MUSIC);
		am.setStreamVolume(AudioManager.STREAM_MUSIC, (int) (volume * max), 0);
	}

	public static void recoveryMusicVolume() {
		AudioManager am = (AudioManager) DDZApplicaion.APP_CONTEXT
				.getSystemService(Context.AUDIO_SERVICE);
		am.setStreamVolume(AudioManager.STREAM_MUSIC,
				WZDDZLua.initial_volume, 0);
	}

	public static void share(String url) {
		Intent it = new Intent(DDZApplicaion.APP_CONTEXT,
				ShareActivity.class);
		it.putExtra("url", url);
		it.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		DDZApplicaion.APP_CONTEXT.startActivity(it);
	}

	public static void share(int mode) {
		String content = "由老马工作室倾情推出的《我爱斗地主》上线啦！快来看看我们的新玩法吧！\n"
				+ "百万巨制，交友神器，和农民一起斗地主，我的地盘我做主。\n" + "一切尽在《我爱斗地主》。\n"
				+ "（分享自@《我爱斗地主》官方网站）";
		Intent intent = new Intent(Intent.ACTION_SEND);
		intent.setType("text/plain");
		intent.putExtra(Intent.EXTRA_SUBJECT, "分享至");
		intent.putExtra(Intent.EXTRA_TEXT, content);
		Intent it = Intent.createChooser(intent, "分享至");
		if (mode > 1) {
			String sd = Environment.getExternalStorageDirectory()
					.getAbsolutePath();
			String pic = sd + "/DCIM/Camera/1.jpg";
			// System.out.println("pic is " + pic);
			it = new Intent(DDZApplicaion.APP_CONTEXT, ShareActivity.class);
			String url1 = "http://service.weibo.com/share/share.php?appkey=2045436852&title="
					+ content
					+ /* "&pic=" + pic + */"&ralateUid=&language=zh_cn";
			String url2 = "http://share.v.t.qq.com/index.php?c=share&a=index&appkey=801192940&title="
					+ content /* + "&pic=" + pic */;
			String url = mode > 2 ? url1 : url2;
			it.putExtra("url", url);
		}
		it.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		DDZApplicaion.APP_CONTEXT.startActivity(it);
	}

	public static String get(String func_name) {
		// System.out.println("func_name is: " + func_name);
		if (func_name.equals("IsNetworkConnected")) {
			return getIsNetworkConnected();
		}
		if (func_name.equals("MusicVolume")) {
			return getMusicVolume();
		}
		if (func_name.equals("CurrentTime")) {
			return getCurrentTime();
		}
		if (func_name.equals("SDCardPath")) {
			return Environment.getExternalStorageDirectory().getAbsolutePath();
		}
		if (func_name.equals("MusicEnabled")) {
//			String result = GameInterface.isMusicEnabled ? "1" : "0";
//			return result;
			return "1";
			//return String.valueOf(GameInterface.isMusicEnabled());
		}
		if (func_name.equals("PackageSignCN")) {
			String cn = getPackageSignCN(WZDDZLua.INSTANCE);
			SharedPreferences sp = WZDDZLua.INSTANCE.getSharedPreferences("Cocos2dxPrefsFile", Context.MODE_PRIVATE);
	        sp.edit().putString("PackageSignCN", cn).commit();
		}
		return "";
	}

	public static String getCurrentTime() {
		long time = System.currentTimeMillis();
		return String.valueOf(time);
	}

	public static String getMusicVolume() {
		AudioManager am = (AudioManager) DDZApplicaion.APP_CONTEXT
				.getSystemService(Context.AUDIO_SERVICE);
		int mVolume = am.getStreamVolume(AudioManager.STREAM_MUSIC);
		int max = am.getStreamMaxVolume(AudioManager.STREAM_MUSIC);
		float percent = (float) mVolume / (float) max;
		// System.out.println("music volume percent is " + percent);
		return String.valueOf(percent);
	}

	public static String getIsNetworkConnected() {
		boolean is_connected = NetworkListener
				.isNetworkConnected(DDZApplicaion.APP_CONTEXT);
		return String.valueOf(is_connected);
	}

	public static String getSign(Context context) {
		try {
			String si = context.getPackageManager().getPackageInfo(
					context.getPackageName(), PackageManager.GET_SIGNATURES).signatures[0]
					.toCharsString();
			return si;
		} catch (Throwable e) {
			e.printStackTrace();
			return null;
		}
	}
	
	public static String getPackageSignCN(Context context) {
		String pkg = context.getPackageName();
		try {
			PackageInfo info = context.getPackageManager().getPackageInfo(pkg,
					PackageManager.GET_SIGNATURES);
			Signature sign = info.signatures[0];
			InputStream certStream = new ByteArrayInputStream(
					sign.toByteArray());
			CertificateFactory certFactory = CertificateFactory
					.getInstance("X509");
			X509Certificate x509Cert = (X509Certificate) certFactory
					.generateCertificate(certStream);
			String subject = x509Cert.getSubjectDN().toString();
			String cn = subject.split(",")[0].split("=")[1];
			return cn;
		} catch (Throwable t) {
			t.printStackTrace();
		}
		return "";
	}
}
