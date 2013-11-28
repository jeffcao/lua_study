package cn.com.m123.DDZ.push;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteDatabase.CursorFactory;
import android.database.sqlite.SQLiteOpenHelper;

public class PushDBHelper extends SQLiteOpenHelper {
	//TODO
	public static final String PUSH_DB_NAME = "push_db";
	public static final String PUSH_TABLE_NAME = "push_table";
	public static final String PUSH_TABLE_PUSHID = "push_id";
	
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
				+ PUSH_TABLE_PUSHID + " TEXT);");
	}

	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
		//version 1, do nothing
	}

}
