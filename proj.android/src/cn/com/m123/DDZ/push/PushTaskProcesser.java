package cn.com.m123.DDZ.push;

import android.content.Context;

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
		// TODO
	}

	private void arrangeTask() {
		// TODO
	}

	private void notification(PushTask task) {
		// TODO
	}

}
