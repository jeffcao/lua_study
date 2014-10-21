package com.ruitong.WZDDZ;

import android.app.Activity;
import android.os.Bundle;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class ShareActivity extends Activity {
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		WebView v = new ProgressWebView(this);
		setContentView(v);
		v.getSettings().setJavaScriptEnabled(true);
		v.setWebViewClient(new WebViewClient(){       
            public boolean shouldOverrideUrlLoading(WebView view, String url) {       
                view.loadUrl(url);       
                return true;       
            }       
		});   
		String url = getIntent().getStringExtra("url");
		v.loadUrl(url);
	}
}
