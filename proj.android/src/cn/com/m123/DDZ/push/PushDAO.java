package cn.com.m123.DDZ.push;

import java.util.List;

import android.content.Context;
import android.database.Cursor;

public class PushDAO {
	private static PushDAO _inst;
	private PushDBHelper db;

	// TODO
	private PushDAO() {
	}

	public static PushDAO getInstance() {
		return null == _inst ? _inst = new PushDAO() : _inst;
	}

	public void init(Context context) {
		if (null != db)
			return;
		db = new PushDBHelper(context.getApplicationContext());
	}

	public long saveTaskArr(List<PushTask> tasks) {
		long result = -1;
		for (PushTask task : tasks) {
			result = db.insert(task.task_id, task.content, task.target_time,
					task.priority, task.condition);
		}
		return result;
	}

	public PushTask getImmediatelyTask() {
		return getOneTaskByCursor(db.getImmediatelyTask());
	}

	public PushTask getLatestTask() {
		return getOneTaskByCursor(db.getLatestTask());
	}
	
	public long removeTask(PushTask task) {
		return db.removeTask(task.task_id);
	}

	private PushTask getOneTaskByCursor(Cursor cursor) {
		if (null == cursor)
			return null;
		try {
			if (cursor.moveToFirst()) {
				return genByCursor(cursor);
			}
		} finally {
			cursor.close();
		}
		return null;
	}

	private PushTask genByCursor(Cursor cursor) {
		PushTask task = new PushTask();
		task.content = cursor.getString(cursor.getColumnIndex(PushDBHelper.PUSH_TABLE_PUSHCONTENT));
		task.priority = cursor.getInt(cursor.getColumnIndex(PushDBHelper.PUSH_TABLE_PUSHPRIORITY));
		task.target_time = cursor.getLong(cursor.getColumnIndex(PushDBHelper.PUSH_TABLE_PUSHTIME));
		task.task_id = cursor.getString(cursor.getColumnIndex(PushDBHelper.PUSH_TABLE_PUSHID));
		task.condition = cursor.getString(cursor.getColumnIndex(PushDBHelper.PUSH_TABLE_PUSHCONDITION));
		return task;
	}
}
