package cn.com.m123.DDZ;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.content.SharedPreferences;
import cn.cmgame.billing.api.BillingResult;
import cn.cmgame.billing.api.GameInterface;
import cn.cmgame.billing.api.GameInterface.IPayCallback;

import com.anzhi.pay.utils.AnzhiPayments;
import com.anzhi.pay.utils.PaymentsInterface;

public class Payments {
	
	public static void pay(String type, String params) {
		if (type.equalsIgnoreCase("anzhi")) {
			anzhi_pay(params);
		} else if (type.equalsIgnoreCase("cmcc")) {
			cmcc_pay(params);
		}
	}
	
	public static void cmcc_pay(String params) {
		try {
			JSONObject json = new JSONObject(params);
			String billingIndex = json.getString("billingIndex");
			String cpparam = json.getString("cpparam");
			String trade_id = json.getString("trade_id");
			String prop_id = json.getString("prop_id");
			dobilling(billingIndex, cpparam, trade_id, prop_id);
		} catch (JSONException e) {
			e.printStackTrace();
		} catch (Throwable t) {
		}
	}
	
	public static void dobilling(String billingIndex, String cpparam, final String trade_id, final String prop_id) {
		String dump = String.format("billingIndex:%s\ncpparam:%s\ntrade_id:%s\nprop_id:%s", new Object[]{billingIndex, cpparam,trade_id,prop_id});
		System.out.println(dump);
		GameInterface.doBilling(DouDiZhu_Lua.getContext(), true, true, billingIndex, cpparam, new IPayCallback() {
			
			@Override
			public void onResult(int resultCode, String billingIndex, Object obj) {
				 String result = "";
			        switch (resultCode) {
			          case BillingResult.SUCCESS:
			            result = "购买道具成功！";
			        //    getPurchaseInfo();
			            break;
			          case BillingResult.FAILED:
			            result = "购买道具失败！";
			            break;
			          default:
			            result = "购买道具取消！";
			            SharedPreferences sp = DouDiZhu_Lua.INSTANCE.getSharedPreferences("Cocos2dxPrefsFile", Context.MODE_PRIVATE);
			            sp.edit().putString("on_bill_cancel", trade_id+"_"+prop_id).commit();
			            DDZJniHelper.messageToCpp("on_bill_cancel");
			            break;
			        }
			        System.out.println(result);
			//        Toast.makeText(DouDiZhu_Lua.getContext(), result, Toast.LENGTH_SHORT).show();
			}
		});
	}
	
	public static void anzhi_pay(String params) {
		String key = "pTgybEN12XWgYWgXctJTW0qv";
		String secret = "TAJ1LBK5YP9OsX3JQT0U6Yx1";
		
		AnzhiPayments payments = AnzhiPayments.getInstance(DouDiZhu_Lua.getContext(), key, secret);
		
		try {
			JSONObject json = new JSONObject(params);
			int which = 1;
			if (!json.isNull("which")) {
				which = Integer.parseInt(json.getString("which"));
			}
			float price = Float.parseFloat(json.getString("price"));
			String desc = json.getString("desc");
			String callBackInfo = json.getString("cpparam");
			final String trade_id = json.getString("trade_id");
			final String prop_id = json.getString("prop_id");
			String str = String.format("which:%d\nprice:%f\ndesc:%s\ncallBackInfo:%s\ntrade_id:%s\nprop_id:%s", 
					new Object[]{which,price,desc,callBackInfo,trade_id,prop_id});
			System.out.println("anzhipay----------------------------\n"+str);
			payments.registerPaymentsCallBack(new PaymentsInterface() {
				
				@Override
				public void onPaymentsWaiting(int arg0, String arg1, float arg2, String arg3) {
					System.out.println("onPaymentsWaiting");
				}
				
				@Override
				public void onPaymentsSuccess(int arg0, String arg1, float arg2) {
					System.out.println("onPaymentsSuccess");
				}
				
				@Override
				public void onPaymentsFail(int arg0, String arg1, float arg2, String arg3) {
					System.out.println("onPaymentsFail");
					notify_cancel();
				}
				
				@Override
				public void onPaymentsEnd() {
					System.out.println("onPaymentsEnd");
					notify_cancel();
				}
				
				@Override
				public void onPaymentsBegin() {
					System.out.println("onPaymentsBegin");
				}
				
				private void notify_cancel() {
					SharedPreferences sp = DouDiZhu_Lua.INSTANCE.getSharedPreferences("Cocos2dxPrefsFile", Context.MODE_PRIVATE);
		            sp.edit().putString("on_bill_cancel", trade_id+"_"+prop_id).commit();
		            DDZJniHelper.messageToCpp("on_bill_cancel");
				}
			});
			payments.pay(which, price, desc, callBackInfo);
		} catch(NumberFormatException nfe) {
			nfe.printStackTrace();
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}
	
}
