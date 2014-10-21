package com.ruitong.WZDDZ;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import org.json.JSONObject;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Environment;
/**
 * {
 * 	"type":"240",
 *  "mode":"prod",
 *  "240":{
 *  	"url":"ws://login.test.170022.cn:8080/websocket"
 *  },
 *  "anzhi":{
 *  	"url":"ws://login.game-test.170022.cn/websocket"
 *  },
 *  "cmcc":{
 *  	"url":"ws://login.game.170022.cn/websocket"
 *  },
 *  "jc":{
 *  	"url":"ws://login.jc.170022.cn/websocket"
 *  }
 * }
 * 
 * 
 * 
 * @author qinyuanz
 *
 */
public class ConfigManager {

	private static String CONFIG_PATH;
	static {
		File f = Environment.getExternalStorageDirectory();
		String file_path = "/tblin/ddz/config.txt";
		if (f == null) {
			CONFIG_PATH = "/mnt/sdcard" + file_path;
		} else {
			CONFIG_PATH = f.getAbsolutePath() + file_path;
			System.out.println("CONFIG_PATH:"+CONFIG_PATH);
		}
	}

	public static void parseConfig() {
		parseContent(getConfigContent());
	}

	private static void parseContent(String content) {
		if (content == null) {
			return;
		}
		String url = "";
		String env = "";
		try {
			JSONObject root = new JSONObject(content);
			env = root.getString("mode");
			String type = root.getString("type");
			JSONObject obj = root.getJSONObject(type);
			url = obj.getString("url");
		} catch (Throwable e) {
			e.printStackTrace();
			return;
		} finally {
			String pref_name = "Cocos2dxPrefsFile";
			SharedPreferences sp = DDZApplicaion.APP_CONTEXT.getSharedPreferences(pref_name, Context.MODE_PRIVATE);
			sp.edit().putString("url", url).commit();
			sp.edit().putString("env", env).commit();
			System.out.println("local url config:" + url);
			System.out.println("local env config:" + env);
		}
	}

	private static String getConfigContent() {
		File configFile = new File(CONFIG_PATH);
		if (configFile.exists()) {
			FileInputStream fis = null;
			StringBuffer sb = new StringBuffer();
			try {
				fis = new FileInputStream(configFile);
				byte[] buffer = new byte[1000];
				int length;
				while ((length = fis.read(buffer)) != -1) {
					sb.append(new String(buffer, 0, length));
				}
				return sb.toString();
			} catch (Exception e) {
				return null;
			} finally {
				if (fis != null)
					try {
						fis.close();
					} catch (IOException e) {
					}
			}
		} else {
			return null;
		}
	}
}
