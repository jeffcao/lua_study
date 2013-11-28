package cn.com.m123.DDZ.push;

import java.util.List;

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

	public interface TaskListener {
		public void onTaskAdd();

		public void onTaskRemove(PushTask task);
	}
}
