/****************************************************************************
Copyright (c) 2010-2012 cocos2d-x.org

http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
 ****************************************************************************/
package cn.com.m123.DDZ;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxGLSurfaceView;

import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.view.KeyEvent;
import cn.cmgame.billing.api.GameInterface;
import cn.cmgame.billing.api.LoginResult;

public class DouDiZhu_Lua extends Cocos2dxActivity {

	public static int initial_volume = 0;
	public static DouDiZhu_Lua INSTANCE;
	public static final int LEYIFU_PAY_REQUEST_CODE = 2014;

	static {
		System.loadLibrary("game");
	}

	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		DDZJniHelper.messageCpp("game_jni");
		INSTANCE = this;
		String payType = ((DouDiZhuApplicaion) getApplication()).getPaytype();
		if ("cmcc".equalsIgnoreCase(payType)) {
			initializeCMCC();
		}
	}

	private void initializeCMCC() {
		DouDiZhuApplicaion.debugLog("cmcc 初始化");
		GameInterface.initializeApp(this);
		GameInterface.setExtraArguments(new String[] { "0000000000000000" });
		GameInterface.ILoginCallback lsnr = new GameInterface.ILoginCallback() {
			@Override
			public void onResult(int i, String s, Object o) {
				String str = "cmcc Login.Result=" + s;
				if (i == LoginResult.SUCCESS_IMPLICIT) {
					str += "\n 隐式登录成功";
				}
				if (i == LoginResult.SUCCESS_EXPLICIT) {
					str += "\n 显式登录成功";
				}
				if (i == LoginResult.FAILED_EXPLICIT) {
					str += "\n 显式登录失败";
				}
				if (i == LoginResult.FAILED_IMPLICIT) {
					str += "\n 隐式登录失败";
				}
				if (i == LoginResult.UNKOWN) {
					str += "\n 用户没有发起登录";
				}
				DouDiZhuApplicaion.debugLog(str);
			}
		};
		GameInterface.setLoginListener(this, lsnr);
	}

	public Cocos2dxGLSurfaceView onCreateView() {
		Cocos2dxGLSurfaceView glSurfaceView = new Cocos2dxGLSurfaceView(this);
		glSurfaceView.setEGLConfigChooser(5, 6, 5, 0, 16, 8);
		return glSurfaceView;
	}

	@Override
	protected void onDestroy() {
		INSTANCE = null;
		super.onDestroy();
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_VOLUME_UP
				|| keyCode == KeyEvent.KEYCODE_VOLUME_DOWN) {
			DDZJniHelper.messageToCpp("on_volume_change");
		}
		return super.onKeyDown(keyCode, event);
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (requestCode == LEYIFU_PAY_REQUEST_CODE) {
			Bundle bundle = data.getExtras();
			if (null != bundle) {
				String is_success = "" + (resultCode == 100);// 是否成功
				String real_price = "" + bundle.getInt("order_price");// 本次支付费用
				String user_order_id = "" + bundle.getString("order_id");// 用户定义的订单号
				String error_code = "" + bundle.getString("pay_result_id");// 支付结果，主要是指错误Code
				String error_msg = "" + bundle.getString("pay_result_msg");// 失败时返回的错误原因
				String[] args = { is_success, real_price, user_order_id,
						error_code, error_msg };
				String str = String.format(
						"是否成功：%s，支付费用：%s，订单号：%s，支付结果：%s，失败原因：%s",
						(Object[]) args);
				DouDiZhuApplicaion.debugLog(str);
				String params = Payments.pollLeyifuCache(user_order_id);
				if (is_success.contains("true")) {// 支付成功
					// Toast.makeText(this, error_msg,
					// Toast.LENGTH_LONG).show();
				} else { // 支付失败
					// Toast.makeText(this, "支付失败:" + error_msg,
					// Toast.LENGTH_LONG).show();
					Payments.doCancelBilling(params);
				}

			}
		}
	}
	
	public static Context getContext(){
	    return INSTANCE;
	}
	
	@Override
	public void onConfigurationChanged(Configuration newConfig) {
		DouDiZhuApplicaion.debugLog("onConfigurationChanged");
		super.onConfigurationChanged(newConfig);
	}

}
