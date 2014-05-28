package com.lbc.rx.demo;

import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.json.JSONException;
import org.json.JSONObject;

import com.bx.pay.BXPay;
import com.bx.pay.backinf.PayCallback;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.content.pm.PermissionInfo;
import android.net.Uri;
import android.os.Bundle;
import android.text.Html;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.View.OnClickListener;
import android.webkit.WebView;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;

public class WpayDemo extends Activity {
	Button pay_but_0001;
	private BXPay bxpay;
	private static String payCode = "0001";
	private Context context;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		context = this;
		super.onCreate(savedInstanceState);
		LinearLayout mianLinearLayout = new LinearLayout(this);
		mianLinearLayout.setGravity(Gravity.CENTER_HORIZONTAL);
		mianLinearLayout.setOrientation(LinearLayout.VERTICAL);
		
		pay_but_0001 = new Button(this);
		pay_but_0001.setText("paycode=0001");
		pay_but_0001.setId(1);
		pay_but_0001.setOnClickListener(clickListener);
		mianLinearLayout.addView(pay_but_0001);
		
		this.setContentView(mianLinearLayout);

	}

	private OnClickListener clickListener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case 1:
				pay("0001");
				break;
			
			default:
				break;
			}
		}
	};



	private void pay(String payCode) {
		if (bxpay == null)
			bxpay = new BXPay(this);
		Map<String, String> devPrivate = new HashMap<String, String>();
		devPrivate.put("开发者要传的KEY值", "开发者要传的VALUE值");
		bxpay.setDevPrivate(devPrivate);//setDevPrivate方式是非必选
		bxpay.pay(payCode, new PayCallback() {

			@Override
			public void pay(Map resultInfo) {	
				// Map resultInfo 主要返回6个字段
				String result= (String) resultInfo.get("result");//描述：  result返回微派支付结果 目前有如下几个状态1、success:成功支付，表示支付成功。2、pass:表示在付费周期里已经成功付费，已经是付费用户。3、pause:表示计费点暂时停止。4、error:本地联网失败、获取不到支付参数等情况。5、fail:支付失败。6、cancel:表示用户取消支付。
				String payType=(String)resultInfo.get("payType");//描述：支付方式类型   目前有如下几个类型   1、	wpay:微派短信支付 。2、	alipay:支付宝支付。3、	czk:充值卡支付。4、	dk:点卡支付。5、	balance：余额支付。6、	uppay:银联支付。
				String payCode= (String)resultInfo.get("payCode");//描述：计费点编号
				String price= (String)resultInfo.get("price");//描述：价格
				String logCode=(String)resultInfo.get("logCode");//订单编号
				String showMsg=(String)resultInfo.get("showMsg");//支付结果详细描述提示

				new AlertDialog.Builder(WpayDemo.this).setTitle("支付结果返回：")
						.setMessage(Html.fromHtml("支付结果："+result+"<br>"+
				                                  "支付类型："+payType+"<br>"+
				                                  "计费点："+payCode+"<br>"+
				                                  "计费价格："+price+"<br>"+
				                                  "订单编号："+logCode+"<br>"+
				                                  "支付结果描述："+showMsg+"<br>"))
						.setPositiveButton("确定", null).show();

			}
		});
	}


}
