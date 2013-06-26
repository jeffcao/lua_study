package com.tblin.DDZ2;

import java.util.Map;
import java.util.Set;

import android.app.Application;
import android.content.Context;
import android.content.SharedPreferences;

public class DouDiZhuApplicaion extends Application {
	public static Context APP_CONTEXT;

	@Override
	public void onCreate() {
		APP_CONTEXT = this;
		super.onCreate();
		saveHardwareInfo();
	}
	
	private void saveHardwareInfo() {
		long start_t = System.currentTimeMillis();
		String pref_name = "Cocos2dxPrefsFile";
		SharedPreferences sp = getSharedPreferences(pref_name, Context.MODE_PRIVATE);
		MobileInfoGetter g = new MobileInfoGetter(this);
		Map<String, String> infos = g.getAllInfo();
		Set<String> keys = infos.keySet();
		SharedPreferences.Editor editor = sp.edit();
		for(String key : keys) {
			editor.putString(key, infos.get(key));
		}
		editor.commit();
		long end_t = System.currentTimeMillis();
		System.out.println("cost time:" + (end_t - start_t));
	}

}
