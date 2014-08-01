package cn.com.m123.DDZ;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONException;
import org.json.JSONObject;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager.NameNotFoundException;
import android.os.Handler;
import android.os.Message;

import com.lyhtgh.pay.SdkPayServer;

public class LetuPayments implements PaymentInterface {
	private static boolean inited = false;
	private String  params, orderId="", pointNum="", payPrice="", productName="", orderDesc="";
	@Override
	public void pay(String params) {
		if (!parseParams(params)) {
			DouDiZhuApplicaion.debugLog("letu 购买解析参数失败");
			return;
		}
		
		if(!inited) {
			int res = SdkPayServer.getInstance().initSdkPayServer();
			DouDiZhuApplicaion.debugLog("letu init result:" +res);
			inited = res == 0;
		}
		
		try {
			SdkPayServer.getInstance().startSdkServerPay(DouDiZhu_Lua.INSTANCE, new LetuHandler(), getOrderInfo());
		} catch (NameNotFoundException e) {
			e.printStackTrace();
		}
	}
	@Override
	public void cancelPay(String params) {
		if (!parseCancelParams(params)) {
			DouDiZhuApplicaion.debugLog("letu 取消购买解析参数失败");
			return;
		}
		
		if(!inited) {
			int res = SdkPayServer.getInstance().initSdkPayServer();
			DouDiZhuApplicaion.debugLog("letu init result:" +res);
			inited = res == 0;
		}
		
		try {
			SdkPayServer.getInstance ().cancelSdkServerPay(DouDiZhu_Lua.INSTANCE, getOrderInfo());
		} catch (NameNotFoundException e) {
			e.printStackTrace();
		}
	}
	
	private boolean parseCancelParams(String params) {
		try {
			JSONObject json = new JSONObject(params);
			pointNum = json.getString("point_num");
			this.params = params;
			return true;
		} catch (JSONException e) {
			e.printStackTrace();
			return false;
		} catch (Throwable t) {
			t.printStackTrace();
			return false;
		}
	}
	
	private boolean parseParams(String params) {
		try {
			JSONObject json = new JSONObject(params);
			orderId = json.getString("trade_id");
			pointNum = json.getString("point_num");
			payPrice = json.getString("price");
			productName = json.getString("name");
			orderDesc = json.getString("desc");
			this.params = params;
			return true;
		} catch (JSONException e) {
			e.printStackTrace();
			return false;
		} catch (Throwable t) {
			t.printStackTrace();
			return false;
		}
	}
	
	@SuppressLint("HandlerLeak")
	private class LetuHandler extends Handler {
		@Override
		public void handleMessage(Message msg) {
			super.handleMessage(msg);

			DouDiZhuApplicaion.debugLog("letu : msg.what = " + msg.what);
			DouDiZhuApplicaion.debugLog("letu : msg.obj = " + msg.obj);
			
			if (msg.what == SdkPayServer.MSG_WHAT_TO_APP) {
				String retInfo = (String) msg.obj;
				DouDiZhuApplicaion.debugLog("letu: ret info" + retInfo);
				
				String[] keyValues = retInfo.split("&|=");
				Map<String, String> resultMap = new HashMap<String, String>();
				for (int i = 0; i < keyValues.length; i = i + 2) {
					resultMap.put(keyValues[i], keyValues[i + 1]);
				}
				
				String payResult = resultMap.get(SdkPayServer.PAYRET_KEY_RESULT_STATUS);
				if (null != payResult && Integer.parseInt(payResult) == SdkPayServer.PAY_RESULT_SUCCESS) {
					DouDiZhuApplicaion.debugLog("letu 付费成功："+resultMap.get(SdkPayServer.PAYRET_KEY_PAIED_PRICE));
					SharedPreferences sp = DouDiZhu_Lua.INSTANCE.getSharedPreferences(
							"Cocos2dxPrefsFile", Context.MODE_PRIVATE);
					sp.edit().putString("on_letu_success", params)
							.commit();
					DDZJniHelper.messageToCpp("on_letu_success");
				}
				else {
					DouDiZhuApplicaion.debugLog("letu 付费失败："+resultMap.get(SdkPayServer.PAYRET_KEY_FAILED_CODE));
					Payments.doCancelBilling(params);
				}
			}
		}}
	
	private String getOrderInfo() throws NameNotFoundException {
		SdkPayServer mSkyPayServer = SdkPayServer.getInstance();
		
		String merchantId = "XZNPAY1001";
		String merchantPasswd = "Z*W6f#2YUkkLZ9&$";
		String payAppId = "3100000";
		
		PackageInfo pkg = DouDiZhu_Lua.INSTANCE.getPackageManager().getPackageInfo(DouDiZhu_Lua.INSTANCE.getApplication().getPackageName(), 0);
		String appName = pkg.applicationInfo.loadLabel(DouDiZhu_Lua.INSTANCE.getPackageManager()).toString();
		String appVer = String.valueOf(pkg.versionCode);
		
		String payType = "1";
		String gameType = "1";
		String channelName = "1000";
		String channelId = DouDiZhuApplicaion.appid;
		
		String sig =  mSkyPayServer.getSignature(merchantPasswd, 
				SdkPayServer.ORDER_INFO_ORDER_ID, orderId, 
				SdkPayServer.ORDER_INFO_MERCHANT_ID, merchantId, 
				SdkPayServer.ORDER_INFO_APP_ID, payAppId, 
                SdkPayServer.ORDER_INFO_APP_VER, appVer, 
                SdkPayServer.ORDER_INFO_APP_NAME, appName, 
                SdkPayServer.ORDER_INFO_PAYPOINT, pointNum, 
                SdkPayServer.ORDER_INFO_PAY_PRICE, payPrice, 
                SdkPayServer.ORDER_INFO_PRODUCT_NAME, productName, 
                SdkPayServer.ORDER_INFO_ORDER_DESC, orderDesc, 
                SdkPayServer.ORDER_INFO_CP_CHANNELID, channelId, 
                SdkPayServer.ORDER_INFO_SDK_CHANNELID, channelName, 
                SdkPayServer.ORDER_INFO_PAY_TYPE, payType, 
                SdkPayServer.ORDER_INFO_GAME_TYPE, gameType
        );
		DouDiZhuApplicaion.debugLog("letu sig:" + sig);
		
		String orderInfo = 
				SdkPayServer.ORDER_INFO_ORDER_ID + "=" + orderId + "&" +
				SdkPayServer.ORDER_INFO_MERCHANT_ID + "=" + merchantId + "&" +
				SdkPayServer.ORDER_INFO_APP_ID + "=" + payAppId + "&" +
                SdkPayServer.ORDER_INFO_APP_VER + "=" + appVer + "&" +
                SdkPayServer.ORDER_INFO_APP_NAME + "=" + appName + "&" +
                SdkPayServer.ORDER_INFO_PAYPOINT + "=" + pointNum + "&" +
                SdkPayServer.ORDER_INFO_PAY_PRICE + "=" + payPrice + "&" +
                SdkPayServer.ORDER_INFO_PRODUCT_NAME + "=" + productName + "&" +
                SdkPayServer.ORDER_INFO_ORDER_DESC + "=" + orderDesc + "&" +
                SdkPayServer.ORDER_INFO_CP_CHANNELID + "=" + channelId + "&" +
                SdkPayServer.ORDER_INFO_SDK_CHANNELID + "=" + channelName + "&" +
                SdkPayServer.ORDER_INFO_PAY_TYPE + "=" + payType + "&" +
                SdkPayServer.ORDER_INFO_GAME_TYPE + "=" + gameType + "&" +
                SdkPayServer.ORDER_INFO_MERCHANT_SIGN + "=" + sig + "&" +
                SdkPayServer.ORDER_INFO_SHOW_PAYUIKEY + "=" + "false";
		
		DouDiZhuApplicaion.debugLog("letu: order " + orderInfo);
		return orderInfo;
	}

}
