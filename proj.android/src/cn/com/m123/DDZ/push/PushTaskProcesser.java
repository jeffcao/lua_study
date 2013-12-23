package cn.com.m123.DDZ.push;

import android.app.Activity;
import android.app.ActivityManager;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import cn.com.m123.DDZ.DouDiZhu_Lua;
import cn.com.m123.DDZ.R;
import cn.com.m123.DDZ.push.PushDataManager.TaskListener;
import cn.com.m123.DDZ.test.Logger;

public class PushTaskProcesser implements TaskListener {
	private Context mContext;
	private int icon_resource = R.drawable.icon;
	private static final String tag = PushTaskProcesser.class.getName();
	
	public PushTaskProcesser(Context mContext) {
		super();
		this.mContext = mContext;
	}

	public void onTaskAlarm() {
		Logger.i(tag, "onTaskAlarm");
		processTask();
	}

	@Override
	public void onTaskAdd() {
		Logger.i(tag, "onTaskAdd");
		processTask();
	}

	@Override
	public void onTaskRemove(PushTask task) {
		// do nothing
	}

	private void processTask() {
		Logger.i(tag, "processTask");
		checkImmediatelyTask();
		arrangeTask();
	}

	private void checkImmediatelyTask() {
		Logger.i(tag, "checkImmediatelyTask");
		PushTask task = PushDAO.getInstance().getImmediatelyTask();
		if (null != task) {
			Logger.i(tag, "get immediately task:\n" + task);
			push(task);
		}
	}

	private void arrangeTask() {
		PushTask latestTask = PushDAO.getInstance().getLatestTask();
		if (null == latestTask || latestTask.getTimeRemain() <= 0)
			return;
		Logger.i(tag, "get latest task:\n" + latestTask);
		AlarmSender.deployAlarm(mContext, PushManager.ACTION_PUSH_ALARM,
				(int) latestTask.getTimeRemain());
	}

	private void push(PushTask task) {
		Logger.i(tag, "push");
		pushNotification(mContext, task, icon_resource);
		PushDAO.getInstance().removeTask(task);
	}

	public static void pushNotification(Context context, PushTask task,
			int icon_resource) {
		Logger.i(tag, "pushNotification");
		if (null != DouDiZhu_Lua.INSTANCE) {
			if (task.condition.equals("background") && isAppForeground(context)) {
				Logger.i(tag, "task can not show while doudizhu game is running");
				return;
			}
			context = DouDiZhu_Lua.INSTANCE;
		}
		NotificationManager nm = (NotificationManager) context
				.getSystemService(Context.NOTIFICATION_SERVICE);
		Notification n = new Notification(icon_resource, task.content,
				System.currentTimeMillis());
		n.flags = Notification.FLAG_AUTO_CANCEL;
		n.defaults |= Notification.DEFAULT_VIBRATE;
		n.sound = Uri.parse("android.resource://" + context.getPackageName()
				+ "/" + R.raw.sound);
		Intent i = new Intent(context, DouDiZhu_Lua.class);

		if (!(context instanceof Activity)) {
			Logger.i(tag,"set flag new task");
			i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		} else {
			Logger.i(tag, "set flag FLAG_ACTIVITY_SINGLE_TOP");
			i.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
		}

		PendingIntent contentIntent = PendingIntent.getActivity(context,
				icon_resource, i, PendingIntent.FLAG_UPDATE_CURRENT);
		n.setLatestEventInfo(context, task.content, task.content, contentIntent);
		nm.notify(icon_resource, n);
	}
	
	private static boolean isAppForeground(Context context) {
		ActivityManager am = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
		ComponentName cn = am.getRunningTasks(2).get(1).topActivity;
		return cn.getPackageName().equals(context.getPackageName());
	}

}
