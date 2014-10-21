package com.ruitong.WZDDZ;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.content.SharedPreferences;

public class Payments {


	
	public static void doCancelBilling(String params) {
		try {
			JSONObject json = new JSONObject(params);
			String trade_id = json.getString("trade_id");
			String prop_id = json.getString("prop_id");
			doCancelBilling(prop_id, trade_id);
		} catch (Throwable e) {
			e.printStackTrace();
		}
	}
	
	public static void doCancelBilling(String prop_id, String trade_id) {
		SharedPreferences sp = WZDDZLua.INSTANCE.getSharedPreferences(
				"Cocos2dxPrefsFile", Context.MODE_PRIVATE);
		sp.edit().putString("on_bill_cancel", trade_id + "_" + prop_id)
				.commit();
		DDZJniHelper.messageToCpp("on_bill_cancel");
	}

	public static PaymentInterface getPaymentObj(String type) {
		return null;
	}

	private static boolean is_leyifu_inited = false;

	public static void pay(String type, String params) {
		getPaymentObj(type).pay(params);
	}
	
	public static void cancelPay(String type, String params) {
		getPaymentObj(type).cancelPay(params);
	}

	

	public static void dobilling(String billingIndex, String cpparam,
			final String trade_id, final String prop_id) {
		String dump = String
				.format("cmcc dobilling billingIndex:%s\ncpparam:%s\ntrade_id:%s\nprop_id:%s",
						new Object[] { billingIndex, cpparam, trade_id, prop_id });
		DDZApplicaion.debugLog(dump);
//		GameInterface.doBilling(WZDDZLua.getContext(), true, true,
//				billingIndex, cpparam, new IPayCallback() {
//
//					@Override
//					public void onResult(int resultCode, String billingIndex,
//							Object obj) {
//						String result = "";
//						switch (resultCode) {
//						case BillingResult.SUCCESS:
//							result = "购买道具成功！";
//							break;
//						case BillingResult.FAILED:
//							result = "购买道具失败！";
//							doCancelBilling(prop_id, trade_id);
//							break;
//						default:
//							result = "购买道具取消！";
//							doCancelBilling(prop_id, trade_id);
//							break;
//						}
//						DDZApplicaion
//								.debugLog("cmcc pay result:" + result);
//					}
//				});
	}

	

}
