package com.example.testmilipay_msmpaydemo;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.Toast;

import com.yuelan.codelib.comm.MyPreference;
import com.yuelan.codelib.utils.TextUtil;
import com.yuelan.dreampay.date.Result;
import com.yuelan.dreampay.listen.OnResultClickListener;
import com.yuelan.dreampay.listen.PayCallback;
import com.yuelan.dreampay.pay.MiLiSmsPay;
import com.yuelan.dreampay.pay.MiLiSmsPaySDK;

public class MainActivity extends Activity {
	private Button pay1;
	private String payId = "51326907";// 找商务索取
	private EditText edit;
	private CheckBox checkBox;
	private MyPreference mp;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		pay1 = (Button) this.findViewById(R.id.button_pay1);
		pay1.setOnClickListener(new PayOnclick());
		edit = (EditText) this.findViewById(R.id.editText);
		checkBox = (CheckBox) this.findViewById(R.id.checkBox1);
		//
		MiLiSmsPaySDK.init(this);
		mp = new MyPreference(this);
		// 初始化方法，放在程序启动的时候
		// dopay();
	}

	class PayOnclick implements OnClickListener {

		@Override
		public void onClick(View v) {
			dopay();
		}
	}

	private void dopay() {
		String payid = edit.getText().toString();
		if (TextUtil.notNull(payid)) {
			payId = payid;
		}
		MiLiSmsPay dreamPay = new MiLiSmsPay(MainActivity.this);
		// 自定义成功和失败提示框显示文本
		dreamPay.setResultText("确定", "返回", "支付成功!", "订购失败!");
		// 设置成功和失败提示框点击事件监听
		dreamPay.setResultListener(new OnResultClickListener() {

			@Override
			public void onclose(String payid, boolean isSuccess) {
				Toast.makeText(MainActivity.this,
						payid + "onclose" + isSuccess, Toast.LENGTH_LONG)
						.show();
			}

			@Override
			public void onclick(String payid, boolean isSuccess) {
				Toast.makeText(MainActivity.this,
						payid + "onclick" + isSuccess, Toast.LENGTH_LONG)
						.show();
			}
		});
		// 支付监听 第3个参数为是否显示支付结果提示框。
		dreamPay.Pay(new PayCallback() {
			@Override
			public void pay(int payResult) {
				if (payResult == 9000) {
					// 成功
					Toast.makeText(MainActivity.this,
							Result.getPayErrorLog(payResult), Toast.LENGTH_LONG)
							.show();
				} else {
					// 支付失败种类很多。请严谨参考开发文档payResult
					Toast.makeText(MainActivity.this,
							Result.getPayErrorLog(payResult), Toast.LENGTH_LONG)
							.show();
				}
			}
		}, payId, checkBox.isChecked());
	}

	@Override
	protected void onStop() {
		mp.write("cs1", edit.getText().toString());
		super.onStop();
	}

	@Override
	protected void onResume() {
		String cs1;
		cs1 = mp.readString("cs1", "");
		if (TextUtil.notNull(cs1)) {
			edit.setText(cs1);
		}
		super.onResume();
	}
}
