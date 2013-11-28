package cn.com.m123.DDZ.push;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.protocol.HTTP;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;

public class NetUtil {

	public static enum HttpMethod {
		GET, POST
	}

	public static boolean isNetworkAvailable(Context context) {
		ConnectivityManager mgr = (ConnectivityManager) context
				.getSystemService(Context.CONNECTIVITY_SERVICE);
		NetworkInfo info = mgr.getActiveNetworkInfo();
		boolean result = null != info && info.isConnected()
				&& info.isAvailable();
		return result;
	}

	public static String syncConnect(final String url,
			final Map<String, String> params, final HttpMethod method) {
		String json = null;
		BufferedReader reader = null;

		try {
			HttpClient client = new DefaultHttpClient();
			HttpUriRequest request = getRequest(url, params, method);
			System.out.println("syncConnect-[REQUEST]:[URL]=>"
					+ request.getURI() + "[PARAMS]=>"
					+ request.getParams().toString());
			HttpResponse response = client.execute(request);

			if (response.getStatusLine().getStatusCode() == HttpStatus.SC_OK) {
				reader = new BufferedReader(new InputStreamReader(response
						.getEntity().getContent()));
				StringBuilder sb = new StringBuilder();
				for (String s = reader.readLine(); s != null; s = reader
						.readLine()) {
					sb.append(s);
				}

				json = sb.toString();
				System.out.println("syncConnect-[RESPONSE]:" + json);
			} else {
				System.out.println("syncConnect-[ERROR]:"
						+ response.getStatusLine().toString());
			}

		} catch (ClientProtocolException e) {
			System.out.println(e.getMessage());
		} catch (IOException e) {
			System.out.println(e.getMessage());
		} finally {
			try {
				if (reader != null) {
					reader.close();
				}
			} catch (IOException e) {
				// ignore me
			}
		}
		return json;
	}

	private static HttpUriRequest getRequest(String url,
			Map<String, String> params, HttpMethod method) {
		if (method.equals(HttpMethod.POST)) {
			return getPostRequest(url, params);
		} else {
			return getGetRequest(url, params);
		}
	}

	private static HttpUriRequest getGetRequest(String url,
			Map<String, String> params) {
		if (url.indexOf("?") < 0) {
			url += "?";
		}
		if (params != null) {
			for (int i = 0; i < params.keySet().size(); i++) {
				String name = (String) params.keySet().toArray()[i];
				if (i == 0) {
					url += name + "=" + URLEncoder.encode(params.get(name));
				} else {
					url += "&" + name + "="
							+ URLEncoder.encode(params.get(name));
				}
			}
		}
		HttpGet request = new HttpGet(url);
		return request;
	}

	private static HttpUriRequest getPostRequest(String url,
			Map<String, String> params) {
		List<NameValuePair> listParams = new ArrayList<NameValuePair>();
		if (params != null) {
			for (String name : params.keySet()) {
				listParams.add(new BasicNameValuePair(name, params.get(name)));
			}
		}
		try {
			UrlEncodedFormEntity entity = new UrlEncodedFormEntity(listParams,
					HTTP.UTF_8);
			HttpPost request = new HttpPost(url);
			request.setEntity(entity);
			return request;
		} catch (UnsupportedEncodingException e) {
			throw new java.lang.RuntimeException(e.getMessage(), e);
		}
	}

}
