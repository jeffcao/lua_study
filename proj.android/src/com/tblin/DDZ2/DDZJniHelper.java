package com.tblin.DDZ2;

import org.cocos2dx.lib.Cocos2dxGLSurfaceView;

import android.content.Context;
import android.media.AudioManager;

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
		if (str.startsWith("set_music_volume_")) {
			System.out.println("set_music_volume is: " + str);
			String volume_str = str.substring(str.lastIndexOf("_") + 1);
			System.out.println("set_music_volume volume is: " + volume_str);
			float volume = Float.parseFloat(volume_str);
			setMusicVolume(volume);
		}
		if (str.equals("RecoveryMusicVolume")) {
			recoveryMusicVolume();
		}
	}
	
	public static void setMusicVolume(float volume) {
		AudioManager am = (AudioManager) DouDiZhuApplicaion.APP_CONTEXT.getSystemService(Context.AUDIO_SERVICE);
		int max = am.getStreamMaxVolume(AudioManager.STREAM_MUSIC);
		am.setStreamVolume(AudioManager.STREAM_MUSIC, (int) (volume * max), 0);
	}
	
	public static void recoveryMusicVolume() {
		AudioManager am = (AudioManager) DouDiZhuApplicaion.APP_CONTEXT.getSystemService(Context.AUDIO_SERVICE);
		am.setStreamVolume(AudioManager.STREAM_MUSIC, DouDiZhu_Lua.initial_volume, 0);
	}
	
	public static String get(String func_name) {
		System.out.println("func_name is: " + func_name);
		if (func_name.equals("IsNetworkConnected")) {
			return getIsNetworkConnected();
		}
		if (func_name.equals("MusicVolume")) {
			return getMusicVolume();
		}
		return "";
	}
	
	public static String getMusicVolume() {
		AudioManager am = (AudioManager) DouDiZhuApplicaion.APP_CONTEXT.getSystemService(Context.AUDIO_SERVICE);
		int mVolume = am.getStreamVolume(AudioManager.STREAM_MUSIC); 
		int max = am.getStreamMaxVolume(AudioManager.STREAM_MUSIC);
		float percent = (float) mVolume / (float) max;
		System.out.println("music volume percent is " + percent);
		return String.valueOf(percent);
	}
	
	public static String getIsNetworkConnected() {
		boolean is_connected = NetworkListener.isNetworkConnected(DouDiZhuApplicaion.APP_CONTEXT);
		return String.valueOf(is_connected);
	}
}
