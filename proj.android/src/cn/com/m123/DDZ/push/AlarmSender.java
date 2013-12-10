package cn.com.m123.DDZ.push;

import java.util.Calendar;

import cn.com.m123.DDZ.test.Logger;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;

public class AlarmSender {

	public static void deployAlarm(Context context, String action, int millisecond) {
		Logger.i("AlarmSender", "deploy alarm " + action + " after " + millisecond + "ms");
		Intent intent = new Intent(action);
		PendingIntent pending = PendingIntent.getBroadcast(context, 0, intent,
				0);
		AlarmManager alarmMgr = (AlarmManager) context
				.getSystemService(Context.ALARM_SERVICE);
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.MILLISECOND, millisecond);
		int type = AlarmManager.RTC_WAKEUP;
		alarmMgr.set(type, calendar.getTimeInMillis(), pending);
	}

}