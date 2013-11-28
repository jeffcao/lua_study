package cn.com.m123.DDZ.push;

import java.util.Map;

import android.content.Context;

import cn.com.m123.DDZ.push.NetUtil.HttpMethod;

public class PushDataFetcher {
	private Thread fetch_thread;
	private Context mContext;
	private PushDataManager push_data_mgr;
	private FetchProtocol fetch_protocol = DEFAULT_PROTOCOL;

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
	}

	public void onAction(String action) {
		fetchData(fetch_protocol.getUrl(), fetch_protocol.getParams());
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
				push_data_mgr.addTask(json);
				fetch_protocol.onFetched(json);
				fetch_thread = null;
			}
		};
		fetch_thread = new Thread(r);
		fetch_thread.start();
	}
	
	public static final FetchProtocol DEFAULT_PROTOCOL = new FetchProtocol() {
		
		@Override
		public void onFetched(String json) {
			//TODO update the latest message_id
		}
		
		@Override
		public String getUrl() {
			return null;
		}
		
		@Override
		public Map<String, String> getParams() {
			return null;
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
