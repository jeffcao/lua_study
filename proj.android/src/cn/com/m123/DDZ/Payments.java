package cn.com.m123.DDZ;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.content.SharedPreferences;
import cn.cmgame.billing.api.BillingResult;
import cn.cmgame.billing.api.GameInterface;
import cn.cmgame.billing.api.GameInterface.IPayCallback;

import com.anzhi.pay.utils.AnzhiPayments;
import com.anzhi.pay.utils.PaymentsInterface;
import com.astep.pay.AppTache;
import com.astep.pay.IInitListener;

public class Payments {

	//because leyifu payment result will be called by activityResult
	//so we must cache order info for trace wich order is return result
	//for other payments, don't need this
	private static Map<String, String> leyifu_cache = new HashMap<String, String>();
	
	public static void saveLeyifuCache(String orderInfo, String params) {
		leyifu_cache.put(orderInfo, params);
	}
	
	public static String pollLeyifuCache(String orderInfo) {
		return leyifu_cache.remove(orderInfo);
	}
	
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
		SharedPreferences sp = DouDiZhu_Lua.INSTANCE.getSharedPreferences(
				"Cocos2dxPrefsFile", Context.MODE_PRIVATE);
		sp.edit().putString("on_bill_cancel", trade_id + "_" + prop_id)
				.commit();
		DDZJniHelper.messageToCpp("on_bill_cancel");
	}

	public static PaymentInterface getPaymentObj(String type) {
		if (type.equalsIgnoreCase("sikai")) {
			return new SkyPayments();
		} else if (type.equalsIgnoreCase("wiipay")) {
			return new WeiPaiPayments();
		} else if (type.equalsIgnoreCase("mili")) {
			return new MiliPayments();
		} else if (type.equalsIgnoreCase("miliuu")) {
			return new MiliuuPayments();
		} else if (type.equalsIgnoreCase("letu")) {
			return new LetuPayments();
		}
		return null;
	}

	private static boolean is_leyifu_inited = false;

	public static void pay(String type, String params) {
		if (type.equalsIgnoreCase("anzhi")) {
			anzhi_pay(params);
		} else if (type.equalsIgnoreCase("cmcc")) {
			cmcc_pay(params);
		} else if (type.equalsIgnoreCase("leyifu")) {
			leyifu_pay(params);
		} else {
			getPaymentObj(type).pay(params);
		}
	}

	public static void leyifu_pay(final String params) {
		if (!is_leyifu_inited) {
			AppTache.init(DouDiZhu_Lua.INSTANCE, new IInitListener() {
				@Override
				public boolean onUpdateStart() {
					return true;
				}

				@Override
				public boolean onUpdateEnd() {
					return true;
				}

				@Override
				public void onInitFinish(int code, String msg) {
					if (code == IInitListener.CODE_FAILED) {
						DouDiZhuApplicaion.debugLog("leyifu init fail:"
								+ (msg == null ? "null" : msg));
						doCancelBilling(params);
					} else if (code == IInitListener.CODE_SUCCESS) {
						DouDiZhuApplicaion.debugLog("leyifu init success");
						is_leyifu_inited = true;
						do_leyifu_pay(params);
					}
				}
			});
			DouDiZhuApplicaion.debugLog("leyifu init start");
		} else {
			do_leyifu_pay(params);
		}
	}

	private static void do_leyifu_pay(String params) {
		try {
			JSONObject json = new JSONObject(params);
			String consume_code = json.getString("consume_code");
			String prop_id = json.getString("prop_id");

			String prop_name = json.getString("prop_name");// param only for
															// leyifu
			float price = Float.parseFloat(json.getString("price"));
			int price_i = (int) price;
			String trade_id = json.getString("trade_id");

			saveLeyifuCache(trade_id, params);
			String dump = String
					.format("leyifu pay=>\nconsume_code:%s\nprop_id:%s\nprop_name:%s\nprice:%d\ntrade_id:%s",
							new Object[] { consume_code, prop_id, prop_name,
									price_i, trade_id });
			DouDiZhuApplicaion.debugLog(dump);
			AppTache.requestPay(DouDiZhu_Lua.INSTANCE, true, price_i, 1,
					consume_code, prop_name, trade_id,
					DouDiZhu_Lua.LEYIFU_PAY_REQUEST_CODE);
		} catch (JSONException e) {
			e.printStackTrace();
		} catch (Throwable t) {
			t.printStackTrace();
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

	public static void dobilling(String billingIndex, String cpparam,
			final String trade_id, final String prop_id) {
		String dump = String
				.format("cmcc dobilling billingIndex:%s\ncpparam:%s\ntrade_id:%s\nprop_id:%s",
						new Object[] { billingIndex, cpparam, trade_id, prop_id });
		DouDiZhuApplicaion.debugLog(dump);
		GameInterface.doBilling(DouDiZhu_Lua.getContext(), true, true,
				billingIndex, cpparam, new IPayCallback() {

					@Override
					public void onResult(int resultCode, String billingIndex,
							Object obj) {
						String result = "";
						switch (resultCode) {
						case BillingResult.SUCCESS:
							result = "购买道具成功！";
							break;
						case BillingResult.FAILED:
							result = "购买道具失败！";
							doCancelBilling(prop_id, trade_id);
							break;
						default:
							result = "购买道具取消！";
							doCancelBilling(prop_id, trade_id);
							break;
						}
						DouDiZhuApplicaion
								.debugLog("cmcc pay result:" + result);
					}
				});
	}

	public static void anzhi_pay(final String params) {
		String key = "pTgybEN12XWgYWgXctJTW0qv";
		String secret = "TAJ1LBK5YP9OsX3JQT0U6Yx1";

		AnzhiPayments payments = AnzhiPayments.getInstance(
				DouDiZhu_Lua.getContext(), key, secret);

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
			String str = String
					.format("which:%d\nprice:%f\ndesc:%s\ncallBackInfo:%s\ntrade_id:%s\nprop_id:%s",
							new Object[] { which, price, desc, callBackInfo,
									trade_id, prop_id });
			DouDiZhuApplicaion
					.debugLog("anzhipay----------------------------\n" + str);
			payments.registerPaymentsCallBack(new PaymentsInterface() {

				@Override
				public void onPaymentsWaiting(int arg0, String arg1,
						float arg2, String arg3) {
					DouDiZhuApplicaion.debugLog("onPaymentsWaiting");
				}

				@Override
				public void onPaymentsSuccess(int arg0, String arg1, float arg2) {
					DouDiZhuApplicaion.debugLog("onPaymentsSuccess");
				}

				@Override
				public void onPaymentsFail(int arg0, String arg1, float arg2,
						String arg3) {
					DouDiZhuApplicaion.debugLog("onPaymentsFail");
					notify_cancel();
				}

				@Override
				public void onPaymentsEnd() {
					DouDiZhuApplicaion.debugLog("onPaymentsEnd");
					notify_cancel();
				}

				@Override
				public void onPaymentsBegin() {
					DouDiZhuApplicaion.debugLog("onPaymentsBegin");
				}

				private void notify_cancel() {
					doCancelBilling(params);
				}
			});
			payments.pay(which, price, desc, callBackInfo);
		} catch (NumberFormatException nfe) {
			nfe.printStackTrace();
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}

}
