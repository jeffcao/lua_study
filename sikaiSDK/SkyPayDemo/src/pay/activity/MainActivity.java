package pay.activity;


import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;

import com.skymobi.pay.sdk.SkyPayServer;
/*
 * 说明：
 * 测试前请将需要的参数核对准确，测试时都是实际付费
 */
public class MainActivity extends Activity {


	private Button mPayButton = null;
	public static TextView mHinTextView = null;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		//注释：startUp 方法是开启游戏时读取第三方页面信息
		int appId = 0;
		SkyPayServer.getInstance().startUp(MainActivity.this, "payMethod=3rd&appid=7001949" + appId);
		
		setContentView(R.layout.main);

		mHinTextView = (TextView) findViewById(R.id.test_textview);
		mPayButton = (Button) findViewById(R.id.button_pay);

		mPayButton.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				/**
				 * 从cp服务端获取订单信息及签名orderInfo
				 * 详见:支付服务端接入demo\tomcat\webapps\payServerDemo\order.jsp
				 */
				String orderInfo = "";
				startPay(MainActivity.this, orderInfo);
			}
		});
	}
	
	public void startPay(Activity activity, String orderInfo) {
		/*
		 * 1.初始化，设置支付回调handle
		 */
		PayCallBackHandle payCallBackHandle = new PayCallBackHandle();
		int initRet = SkyPayServer.getInstance().init(payCallBackHandle);
		if (SkyPayServer.PAY_RETURN_SUCCESS == initRet) {
			//初始化成功！
		} else {
			//可能连续点击引起的
			Log.i("pay", "初始化失败:" + initRet);
		}

		//2、启动付费
		int payRet = SkyPayServer.getInstance().startActivityAndPay(activity, orderInfo);
    	if (SkyPayServer.PAY_RETURN_SUCCESS == payRet) {
    		//初始化成功
    		Log.i("pay", "接口斯凯付费调用成功");
    	} else {
    		//未初始化 \传入参数有误 \服务正处于付费状态
    		Log.i("pay", "调用接口失败:" + payRet);
    	}
	}
}
