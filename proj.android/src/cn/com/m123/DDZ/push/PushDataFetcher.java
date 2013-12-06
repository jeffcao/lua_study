package cn.com.m123.DDZ.push;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.content.SharedPreferences;
import cn.com.m123.DDZ.push.NetUtil.HttpMethod;
import cn.com.m123.DDZ.test.Test;

public class PushDataFetcher {
	private Thread fetch_thread;
	private Context mContext;
	private PushDataManager push_data_mgr;
	private FetchProtocol fetch_protocol;

	public void setFetch_protocol(FetchProtocol fetch_protocol) {
		this.fetch_protocol = fetch_protocol;
	}

	public FetchProtocol getFetch_protocol() {
		return fetch_protocol;
	}

	public PushDataFetcher(Context mContext, PushDataManager push_data_mgr) {
		super();
		this.mContext = mContext;
		this.push_data_mgr = push_data_mgr;
		this.fetch_protocol = DEFAULT_PROTOCOL;
	}

	public void onAction(String action) {
		AlarmSender.deployAlarm(mContext, PushManager.ACTION_FETCH_ALARM, fetch_protocol.getFetchInterval());
		Map<String, String> params = fetch_protocol.getParams();
		String url = fetch_protocol.getUrl();
		if (null != params && null != url) {
			fetchData(url, params);
		}
	}

	public void fetchData(final String url, final Map<String, String> params) {
		if (null != fetch_thread)
			return;
		if (!NetUtil.isNetworkAvailable(mContext))
			return;
		Runnable r = new Runnable() {

			@Override
			public void run() {
				String json = NetUtil.syncConnect(url, params, HttpMethod.POST);
			//	json = Test.getTestJson(mContext);
				System.out.println("json is " + json);
			//	push_data_mgr.addTask(json);
				fetch_protocol.onFetched(json);
				fetch_thread = null;
			}
		};
		fetch_thread = new Thread(r);
		fetch_thread.start();
	}
	
	public final FetchProtocol DEFAULT_PROTOCOL = new FetchProtocol() {
		
		@Override
		public void onFetched(String json) {
			try {
				JSONObject obj = new JSONObject(json);
				String last_message_seq = String.valueOf(obj.getInt("last_msg_seq"));
				SharedPreferences sp = mContext.getSharedPreferences("push_task", Context.MODE_PRIVATE);
				sp.edit().putString("last_message_seq", last_message_seq).commit();
				
				JSONArray messages = obj.getJSONArray("messages");
				push_data_mgr.addTask(messages);
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
		
		@Override
		public String getUrl() {
			return "http://192.168.0.203:5004/sys_msg/notification_msg";
		}
		
		@Override
		public Map<String, String> getParams() {
			SharedPreferences sp = mContext.getSharedPreferences("push_task", Context.MODE_PRIVATE);
			String last_msg_seq = sp.getString("last_msg_seq", "0");
			sp = mContext.getSharedPreferences("Cocos2dxPrefsFile", Context.MODE_PRIVATE);
			String user_id = sp.getString("user.user_ids", null);
			if (null == user_id) return null;
			String[] user_ids = user_id.split(",");
			if (null == user_ids || user_ids.length == 0) return null;
			user_id = user_ids[0];
			Map<String, String> params = new HashMap<String, String>();
			params.put("last_msg_seq", last_msg_seq);
			params.put("user_id", user_id);
			return params;
		}
		
		@Override
		public int getFetchInterval() {
			return 30 * 60 * 1000;
		}
	};
	
	
	public interface FetchProtocol {
		
		public int getFetchInterval();
		
		public String getUrl();

		public void onFetched(String json);

		public Map<String, String> getParams();
	}

}
