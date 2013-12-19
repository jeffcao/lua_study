package cn.com.m123.DDZ.push;

import cn.com.m123.DDZ.test.Logger;
import android.content.Context;
/**
 * how to use!
 * must set in Application
 *    PushManager.getInstance().init(this)
 * must declared in Manifest.xml
 *    service:{@PushService}
 *    receiver:{@PushReceiver}
 * @author qy
 *
 */

public class PushManager {
	public static String ACTION_FETCH_ALARM = ".fetch_alarm";
	public static String ACTION_PUSH_ALARM = ".push_alarm";

	private Context mContext;
	private PushDataFetcher data_fetcher;
	private PushTaskProcesser task_processer;
	private PushDataManager data_manager;

	private static PushManager _inst;
	private static final String tag = PushManager.class.getName();
	
	private PushManager() {
	}

	public PushDataManager getData_manager() {
		return data_manager;
	}

	public static PushManager getInstance() {
		return null == _inst ? _inst = new PushManager() : _inst;
	}

	public PushManager init(Context context) {
		if (null != this.mContext)
			return this;
		this.mContext = context;
		data_manager = new PushDataManager(this.mContext);
		data_fetcher = new PushDataFetcher(this.mContext, data_manager);
		task_processer = new PushTaskProcesser(this.mContext);
		data_manager.setTaskListener(task_processer);
		ACTION_FETCH_ALARM = mContext.getPackageName() + ACTION_FETCH_ALARM;
		ACTION_PUSH_ALARM = mContext.getPackageName() + ACTION_PUSH_ALARM;
		return this;
	}

	public void onAction(String action) {
		Logger.i(tag, "on action " + action + "\n  at time:" 
					+ PushTask.transTime(System.currentTimeMillis()));
		if (ACTION_PUSH_ALARM.equals(action)) {
			task_processer.onTaskAlarm();
		}
		data_fetcher.onAction(action);
	}

	public void destroy() {
		data_manager.destroy();
	}

}
