package cn.com.m123.DDZ.test;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;

import android.content.Context;
import cn.com.m123.DDZ.R;
import cn.com.m123.DDZ.push.AlarmSender;
import cn.com.m123.DDZ.push.PushManager;

public class Test {
	
	public static void testFetch(Context context) {
		AlarmSender.deployAlarm(context, PushManager.ACTION_FETCH_ALARM, 3000);
	}
	
	public static String getTestJson(Context context) {
		InputStream fis = null;
		try {
			fis = context.getResources().openRawResource(R.raw.json);
			StringBuilder sb = new StringBuilder();
			byte[] buffer = new byte[1024];
			int read = -1;
			while((read = fis.read(buffer)) != -1) {
				sb.append(new String(buffer, 0, read));
			}
			return sb.toString();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (null != fis)
				try {
					fis.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
		}
		return "";
	}
}
