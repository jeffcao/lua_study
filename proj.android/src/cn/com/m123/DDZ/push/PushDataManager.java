package cn.com.m123.DDZ.push;

import java.util.List;

import android.app.Activity;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import cn.com.m123.DDZ.DouDiZhu_Lua;
import cn.com.m123.DDZ.R;

public class PushDataManager {
	private Context mContext;
	private TaskListener taskListener;
	private PushDAO push_dao;

	public PushDataManager(Context mContext) {
		super();
		this.mContext = mContext;
		push_dao = PushDAO.getInstance();
		push_dao.init(this.mContext);
	}

	public void setTaskListener(TaskListener taskListener) {
		this.taskListener = taskListener;
	}

	public void addTask(String json) {
		List<PushTask> tasks = PushTask.parseJsonArray(json);
		if (null == tasks || tasks.isEmpty())
			return;
		long result = push_dao.saveTaskArr(tasks);
		if (-1 != result && null != this.taskListener)
			this.taskListener.onTaskAdd();
	}

	public void removeTask(PushTask task) {
		if (null == task.task_id)
			return;
		long result = push_dao.removeTask(task);
		if (-1 != result && null != this.taskListener)
			this.taskListener.onTaskRemove(task);
	}

	public PushTask getImmediatelyTask() {
		return push_dao.getImmediatelyTask();
	}

	public PushTask getLatestTask() {
		return push_dao.getLatestTask();
	}

	public void destroy() {
		this.taskListener = null;
	}

	public static void pushNotification(Context context, PushTask task) {
		if (null != DouDiZhu_Lua.INSTANCE)
			context = DouDiZhu_Lua.INSTANCE;
		NotificationManager nm = (NotificationManager) context
				.getSystemService(Context.NOTIFICATION_SERVICE);
		Notification n = new Notification(R.drawable.icon, "Hello,there!",
				System.currentTimeMillis());
		n.flags = Notification.FLAG_AUTO_CANCEL;
		n.defaults |= Notification.DEFAULT_VIBRATE;
		n.sound = Uri.parse("android.resource://" + context.getPackageName() + "/" + R.raw.sound);
		Intent i = new Intent(context, DouDiZhu_Lua.class);

		if (!(context instanceof Activity)) {
			System.out.println("set flag new task");
			i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		} else {
			System.out.println("set flag FLAG_ACTIVITY_SINGLE_TOP");
			i.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
		}
		
		PendingIntent contentIntent = PendingIntent.getActivity(context,
				R.string.app_name, i, PendingIntent.FLAG_UPDATE_CURRENT);
		n.setLatestEventInfo(context, "Hello,there!", "Hello,there,I'm john.",
				contentIntent);
		nm.notify(R.string.app_name, n);
	}

	public interface TaskListener {
		public void onTaskAdd();

		public void onTaskRemove(PushTask task);
	}
}
