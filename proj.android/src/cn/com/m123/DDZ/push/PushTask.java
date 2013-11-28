package cn.com.m123.DDZ.push;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class PushTask {
	//TODO
	public long target_time = -1;
	public String task_id = null;
	
	public static List<PushTask> parseJsonArray(String json_arr) {
		if (null == json_arr) return null;
		try {
			return parseJsonArray(new JSONArray(json_arr));
		} catch (JSONException e) {
			e.printStackTrace();
			return null;
		}
	}
	
	public static List<PushTask> parseJsonArray(JSONArray json_arr) {
		List<PushTask> tasks = new ArrayList<PushTask>();
		for (int i = 0; i < json_arr.length(); i++) {
			try {
				PushTask task = parseJsonObject(json_arr.getJSONObject(i));
				if (null != task) tasks.add(task);
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
		return tasks;
	}

	public static PushTask parseJsonObject(String json) {
		if (null == json) return null;
		try {
			return parseJsonObject(new JSONObject(json));
		} catch (JSONException e) {
			e.printStackTrace();
			return null;
		}
	}
	
	public static PushTask parseJsonObject(JSONObject obj) {
		//TODO
		return null;
	}
	
}
