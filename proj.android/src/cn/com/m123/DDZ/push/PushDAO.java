package cn.com.m123.DDZ.push;

import java.util.List;

import android.content.Context;

public class PushDAO {
	private static PushDAO _inst;
	private PushDBHelper db;
	//TODO
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
		return -1;
	}

	public PushTask getImmediatelyTask() {
		return null;
	}

	public PushTask getLatestTask() {
		return null;
	}

	public long removeTask(PushTask task) {
		return -1;
	}
}
