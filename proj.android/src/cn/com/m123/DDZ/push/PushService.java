package cn.com.m123.DDZ.push;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;

public class PushService extends Service {

	@Override
	public IBinder onBind(Intent intent) {
		return null;
	}

	@Override
	public void onCreate() {
		super.onCreate();
	}

	@Override
	@Deprecated
	public void onStart(Intent intent, int startId) {
		String action = null;
		if (null != intent)
			action = intent.getAction();
		PushManager.getInstance().onAction(action);
		super.onStart(intent, startId);
	}

	@Override
	public void onDestroy() {
		startService(new Intent(this, getClass()));
		super.onDestroy();
	}

}
