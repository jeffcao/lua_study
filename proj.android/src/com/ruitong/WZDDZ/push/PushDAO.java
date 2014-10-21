package com.ruitong.WZDDZ.push;

import java.util.ArrayList;
import java.util.List;

import com.ruitong.WZDDZ.test.Logger;

import android.content.Context;
import android.database.Cursor;

public class PushDAO {
	private static PushDAO _inst;
	private PushDBHelper db;
	private final String tag = PushDAO.class.getName();

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
			Logger.i(tag, "save task\n" + task + "\nresult:" + result);
		}
		dumpDb("after saveTaskArr");
		return result;
	}

	public PushTask getImmediatelyTask() {
		dumpDb("before getImmediatelyTask");
		return getOneTaskByCursor(db.getImmediatelyTask());
	}

	public PushTask getLatestTask() {
		dumpDb("before getLatestTask");
		return getOneTaskByCursor(db.getLatestTask());
	}
	
	public long removeTask(PushTask task) {
		long result = db.removeTask(task.task_id);
		Logger.i(tag, "remove task\n" + task + "\nresult:" + result);
		dumpDb("after remove task");
		return result;
	}
	
	private void dumpDb(String reason) {
		//TODO for test
		Logger.i(tag, "dump db for " + reason + "\n");
		List<PushTask> tasks = getAllTask();
		if (tasks.isEmpty()) {
			Logger.i(tag, "db is empty");
		} else {
			Logger.i(tag, "db has tasks\n");
			for(PushTask task : tasks) {
				Logger.i(tag, "db task=>" + task);
			}
		}
	}
	
	private List<PushTask> getAllTask() {
		Cursor c = db.getAllTask();
		return genTasksByCursor(c);
	}

	private List<PushTask> genTasksByCursor(Cursor c) {
		List<PushTask> tasks = new ArrayList<PushTask>();
		if (null == c) return tasks;
		try {
			while(c.moveToNext()) {
				PushTask task = genByCursor(c);
				tasks.add(task);
			}
		} finally {
			c.close();
		}
		return tasks;
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
