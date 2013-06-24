package com.tblin.DDZ2;

import android.app.Application;
import android.content.Context;

public class DouDiZhuApplicaion extends Application {
	public static Context APP_CONTEXT;

	@Override
	public void onCreate() {
		APP_CONTEXT = this;
		super.onCreate();
	}
}
