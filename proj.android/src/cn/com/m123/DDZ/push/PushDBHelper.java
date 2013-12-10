package cn.com.m123.DDZ.push;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteDatabase.CursorFactory;
import android.database.sqlite.SQLiteOpenHelper;

public class PushDBHelper extends SQLiteOpenHelper {
	//TODO
	public static final String PUSH_DB_NAME = "push_db";
	public static final String PUSH_TABLE_NAME = "push_table";
	
	public static final String PUSH_TABLE_PUSHID = "push_id";
	public static final String PUSH_TABLE_PUSHCONTENT = "push_content";
	public static final String PUSH_TABLE_PUSHTIME = "push_time";
	public static final String PUSH_TABLE_PUSHPRIORITY = "push_priority";
	public static final String PUSH_TABLE_PUSHCONDITION = "push_condition";
	
	public PushDBHelper(Context context) {
		this(context, PUSH_DB_NAME, null, 1);
	}
	
	public PushDBHelper(Context context, String name, CursorFactory factory,
			int version) {
		super(context, name, factory, version);
	}

	@Override
	public void onCreate(SQLiteDatabase db) {
		db.execSQL("create table " + PUSH_TABLE_NAME
				+ " ( _id INTEGER PRIMARY KEY AUTOINCREMENT, "
				+ PUSH_TABLE_PUSHID + " TEXT, "
				+ PUSH_TABLE_PUSHCONTENT + " TEXT, "
				+ PUSH_TABLE_PUSHTIME + " LONG, "
				+ PUSH_TABLE_PUSHCONDITION + " TEXT, "
				+ PUSH_TABLE_PUSHPRIORITY + " INTEGER);");
	}

	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
		//version 1, do nothing
	}
	
	public long insert(String pushid, String content, long time, int prioriy, String condition) {
		ContentValues values = new ContentValues();
		values.put(PUSH_TABLE_PUSHID, pushid);
		values.put(PUSH_TABLE_PUSHCONTENT, content);
		values.put(PUSH_TABLE_PUSHTIME, time);
		values.put(PUSH_TABLE_PUSHPRIORITY, prioriy);
		values.put(PUSH_TABLE_PUSHCONDITION, condition);
		return getWritableDatabase().insert(PUSH_TABLE_NAME, null, values);
	}
	
	public Cursor getAllTask() {
		String sql = "select * from " + PUSH_TABLE_NAME;
		return getReadableDatabase().rawQuery(sql, null);
	}
	
	public Cursor getImmediatelyTask() {
		String sql = "select * from " + PUSH_TABLE_NAME + " where " + PUSH_TABLE_PUSHTIME + "<?" 
					 + " order by " + PUSH_TABLE_PUSHTIME + " desc";
		return getReadableDatabase().rawQuery(sql, new String[]{String.valueOf(System.currentTimeMillis())});
	}
	
	public Cursor getLatestTask() {
		String sql = "select * from " + PUSH_TABLE_NAME + " where " + PUSH_TABLE_PUSHTIME + ">?" 
				 + " order by " + PUSH_TABLE_PUSHTIME + " asc";
		return getReadableDatabase().rawQuery(sql, new String[]{String.valueOf(System.currentTimeMillis())});
	}
	
	public long removeTask(String taskid) {
		return getWritableDatabase().delete(PUSH_TABLE_NAME, PUSH_TABLE_PUSHID + "=?", new String[]{taskid});
	}

}
