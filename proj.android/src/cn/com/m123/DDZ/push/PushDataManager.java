package cn.com.m123.DDZ.push;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;

import android.content.Context;

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
	
	public void addTask(JSONArray json_arr) {
		List<PushTask> tasks = PushTask.parseJsonArray(json_arr);
		addTasks(tasks);
	}

	public void addTask(String json) {
		List<PushTask> tasks = PushTask.parseJsonArray(json);
		addTasks(tasks);
	}

	private void addTasks(List<PushTask> tasks) {
		if (null == tasks || tasks.isEmpty())
			return;
		//去除一天之前的推送
		List<PushTask> notoutdates = new ArrayList<PushTask>();
		for(PushTask task : tasks) {
			if (!isOutOfDate(task)) {
				notoutdates.add(task);
			}
		}
		long result = push_dao.saveTaskArr(notoutdates);
		if (-1 != result && null != this.taskListener)
			this.taskListener.onTaskAdd();
	}
	
	private boolean isOutOfDate(PushTask task) {
		long day = 24 * 60 * 1000 * 1000;
		boolean result = System.currentTimeMillis() - task.target_time > day;
		return result;
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

	public interface TaskListener {
		public void onTaskAdd();

		public void onTaskRemove(PushTask task);
	}
}
