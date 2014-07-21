package cn.com.m123.DDZ;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.content.SharedPreferences;

import com.yuelan.dreampay.listen.PayCallback;
import com.yuelan.dreampay.pay.MiLiSmsPay;
import com.yuelan.dreampay.pay.MiLiSmsPaySDK;

public class MiliPayments implements PaymentInterface {

	protected static MiLiSmsPay mPay;
	private String payId;
	private String trade_id;
	private String prop_id;
	private static final int SUCCESS_CODE = 9000;
	@Override
	public void pay(String params) {
		if (!parseParams(params)) {
			DouDiZhuApplicaion.debugLog(getPayType() + " 解析参数失败");
			return;
		}
		
		if (null == mPay) {
			MiLiSmsPaySDK.init(DouDiZhu_Lua.INSTANCE);
			mPay = new MiLiSmsPay(DouDiZhu_Lua.INSTANCE);
		}
		do_mili_pay(params);
	}
	
	protected String getPayType() {
		return "mili";
	}
	
	private void do_mili_pay(final String params) {
		DouDiZhuApplicaion.debugLog("mili: pay id is " + payId);
		mPay.Pay(new PayCallback() {
			
			@Override
			public void pay(int result_code) {
				if (result_code == SUCCESS_CODE) {
					DouDiZhuApplicaion.debugLog(getPayType() + " 付费调用成功");
					SharedPreferences sp = DouDiZhu_Lua.INSTANCE.getSharedPreferences(
							"Cocos2dxPrefsFile", Context.MODE_PRIVATE);
					sp.edit().putString("on_"+getPayType()+"_success", params)
							.commit();
					DDZJniHelper.messageToCpp("on_"+getPayType()+"_success");
				} else {
					DouDiZhuApplicaion.debugLog(getPayType() + " 付费调用失败:" + result_code);
					Payments.doCancelBilling(params);
				}
			}
		}, payId, true);
	}

	private boolean parseParams(String params) {
		try {
			JSONObject json = new JSONObject(params);
			payId = json.getString("pay_id");
			trade_id = json.getString("trade_id");
			prop_id = json.getString("prop_id");
			return true;
		} catch (JSONException e) {
			e.printStackTrace();
			return false;
		} catch (Throwable t) {
			t.printStackTrace();
			return false;
		}
	}
}
