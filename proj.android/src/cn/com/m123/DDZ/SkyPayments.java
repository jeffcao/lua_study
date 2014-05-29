package cn.com.m123.DDZ;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONException;
import org.json.JSONObject;

import android.os.Handler;
import android.os.Message;

import com.skymobi.pay.sdk.SkyPayServer;

public class SkyPayments implements PaymentInterface {
	protected static boolean is_sikai_startuped = false;

	private String initInfo = "payMethod=3rd&appid=7001949";
	private String orderInfo;
	private String params;

	@Override
	public void pay(String params) {
		if (!parseParams(params)) {
			DouDiZhuApplicaion.debugLog("sikai 解析参数失败");
			return;
		}

		if (!is_sikai_startuped) {
			SkyPayServer.getInstance().startUp(DouDiZhu_Lua.INSTANCE, initInfo);
			is_sikai_startuped = true;
			do_sikai_pay(params);
		} else {
			do_sikai_pay(params);
		}
	}

	private boolean parseParams(String params) {
		try {
			this.params = params;
			JSONObject json = new JSONObject(params);
			orderInfo = json.getString("orderInfo");
			if (!json.isNull("initInfo")) {
				//如果服务器传了这个参数，就使用服务器的参数
				initInfo = json.getString("initInfo");
			}
			return true;
		} catch (JSONException e) {
			e.printStackTrace();
			return false;
		} catch (Throwable t) {
			t.printStackTrace();
			return false;
		}
	}

	public void do_sikai_pay(String params) {
		Handler payCallBackHandle = new SkyPaymentHandler() ;
		int initRet = SkyPayServer.getInstance().init(payCallBackHandle);
		if (SkyPayServer.PAY_RETURN_SUCCESS == initRet) {
			DouDiZhuApplicaion.debugLog("sikai init success");
			int payRet = SkyPayServer.getInstance().startActivityAndPay(
					DouDiZhu_Lua.INSTANCE, orderInfo);
			if (SkyPayServer.PAY_RETURN_SUCCESS == payRet) {
				DouDiZhuApplicaion.debugLog("sikai 付费调用成功");
			} else {
				Payments.doCancelBilling(this.params);
				DouDiZhuApplicaion.debugLog("sikai 付费调用失败:" + payRet);
			}
		} else {
			Payments.doCancelBilling(this.params);
			DouDiZhuApplicaion.debugLog("sikai init fail:" + initRet);
		}
	}

	class SkyPaymentHandler extends Handler {
		public static final String STRING_MSG_CODE = "msg_code";
		public static final String STRING_PAY_STATUS = "pay_status";
		public static final String STRING_CHARGE_STATUS = "3rdpay_status";

		@Override
		public void handleMessage(Message msg) {
			super.handleMessage(msg);
			if (msg.what == SkyPayServer.MSG_WHAT_TO_APP) {
				// 形式：key-value
				String retInfo = (String) msg.obj;
				DouDiZhuApplicaion.debugLog("sikai 付费调用结果:" + retInfo);
				Map<String, String> map = new HashMap<String, String>();
				String[] keyValues = retInfo.split("&|=");
				for (int i = 0; i < keyValues.length; i = i + 2) {
					map.put(keyValues[i], keyValues[i + 1]);
				}

				int msgCode = Integer.parseInt(map.get(STRING_MSG_CODE));
				if (msgCode == 101) {
					/**
					 * 返回错误 retInfo格式：msg_code=101&error_code=***
					 * error_code取值参考文档
					 */
					Payments.doCancelBilling(params);
					return;
				}

				if (map.get(STRING_PAY_STATUS) != null) {
					/**
					 * 短信付费结果返回 retInfo失败格式：msg_code=100&pay_status=101&
					 * pay_price=0&errorcode=*** retInfo成功格式：msg_code=100
					 * &pay_status=102&pay_price=*** 具体参数意义参考文档
					 */
				} else if (map.get(STRING_CHARGE_STATUS) != null) {
					/**
					 * 第三方付费结果返回 retInfo格式：msg_code=100&3rdpay_status=***
					 * &pay_price=***&skyChargeId=*** 具体参数意义参考文档
					 */
				}
			}
		}
	}
}
