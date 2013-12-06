package cn.com.m123.DDZ.push;

import android.app.Activity;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import cn.com.m123.DDZ.DouDiZhu_Lua;
import cn.com.m123.DDZ.R;
import cn.com.m123.DDZ.push.PushDataManager.TaskListener;

public class PushTaskProcesser implements TaskListener {
	private Context mContext;
	private int icon_resource = android.R.drawable.star_big_on;

	public PushTaskProcesser(Context mContext) {
		super();
		this.mContext = mContext;
	}

	public void setIcon_resource(int icon_resource) {
		this.icon_resource = icon_resource;
	}

	public void onTaskAlarm() {
		processTask();
	}

	@Override
	public void onTaskAdd() {
		processTask();
	}

	@Override
	public void onTaskRemove(PushTask task) {
		// do nothing
	}

	private void processTask() {
		checkImmediatelyTask();
		arrangeTask();
	}

	private void checkImmediatelyTask() {
		PushTask task = PushDAO.getInstance().getImmediatelyTask();
		if (null != task)
			push(task);
	}

	private void arrangeTask() {
		PushTask latestTask = PushDAO.getInstance().getLatestTask();
		if (null == latestTask || latestTask.getTimeRemain() <= 0)
			return;
		AlarmSender.deployAlarm(mContext, PushManager.ACTION_PUSH_ALARM,
				(int) latestTask.getTimeRemain());
	}

	private void push(PushTask task) {
		pushNotification(mContext, task, icon_resource);
		PushDAO.getInstance().removeTask(task);
	}

	public static void pushNotification(Context context, PushTask task,
			int icon_resource) {
		if (null != DouDiZhu_Lua.INSTANCE) {
			if (task.condition.equals("background")) {
				System.out.println("task can not show while doudizhu game is running");
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
			System.out.println("set flag new task");
			i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		} else {
			System.out.println("set flag FLAG_ACTIVITY_SINGLE_TOP");
			i.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
		}

		PendingIntent contentIntent = PendingIntent.getActivity(context,
				icon_resource, i, PendingIntent.FLAG_UPDATE_CURRENT);
		n.setLatestEventInfo(context, task.content, task.content, contentIntent);
		nm.notify(icon_resource, n);
	}

}
