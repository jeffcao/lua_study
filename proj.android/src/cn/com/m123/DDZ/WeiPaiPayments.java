package cn.com.m123.DDZ;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONException;
import org.json.JSONObject;

import android.text.Html;

import com.bx.pay.BXPay;
import com.bx.pay.backinf.PayCallback;

public class WeiPaiPayments implements PaymentInterface {
	private static BXPay pay;
	private String payCode;
	private String devPrivateKey;
	private String devPrivateValue;
	@Override
	public void pay(String params) {
		DouDiZhuApplicaion.debugLog("weipai: start pay");

		if (!parseParams(params)) {
			DouDiZhuApplicaion.debugLog("weipai: 解析参数失败");
			return;
		}

		if (null == pay) {
			pay = new BXPay(DouDiZhu_Lua.INSTANCE);
		}
		Map<String, String> devPrivate = new HashMap<String, String>();
		devPrivate.put(devPrivateKey, devPrivateValue);
		pay.setDevPrivate(devPrivate);
		pay.pay(payCode, new WeiPayCallback());
	}

	private boolean parseParams(String params) {
		try {
			JSONObject json = new JSONObject(params);
			payCode = json.getString("payCode");
			JSONObject devPrivate = json.getJSONObject("devPrivate");
			devPrivateKey = (String) devPrivate.keys().next();
			devPrivateValue = devPrivate.getString(devPrivateKey);
			String str = String.format("weipai: payCode:%s, devPriavte:%s=%s",  new Object[]{payCode, devPrivateKey, devPrivateValue});
			DouDiZhuApplicaion.debugLog(str);
		//	devPrivate = json.getString("devPrivate");
			return true;
		} catch (JSONException e) {
			e.printStackTrace();
			return false;
		} catch (Throwable t) {
			t.printStackTrace();
			return false;
		}
	}

	class WeiPayCallback implements PayCallback {

		@Override
		public void pay(Map resultInfo) {
			// Map resultInfo 主要返回6个字段
			String result = (String) resultInfo.get("result");// 描述：
																// result返回微派支付结果
																// 目前有如下几个状态1、success:成功支付，表示支付成功。2、pass:表示在付费周期里已经成功付费，已经是付费用户。3、pause:表示计费点暂时停止。4、error:本地联网失败、获取不到支付参数等情况。5、fail:支付失败。6、cancel:表示用户取消支付。
			String payType = (String) resultInfo.get("payType");// 描述：支付方式类型
																// 目前有如下几个类型 1、
																// wpay:微派短信支付
																// 。2、
																// alipay:支付宝支付。3、
																// czk:充值卡支付。4、
																// dk:点卡支付。5、
																// balance：余额支付。6、
																// uppay:银联支付。
			String payCode = (String) resultInfo.get("payCode");// 描述：计费点编号
			String price = (String) resultInfo.get("price");// 描述：价格
			String logCode = (String) resultInfo.get("logCode");// 订单编号
			String showMsg = (String) resultInfo.get("showMsg");// 支付结果详细描述提示

			String resultStr = Html.fromHtml(
					"weipay: 支付结果：" + result + "<br>" + "支付类型：" + payType
							+ "<br>" + "计费点：" + payCode + "<br>" + "计费价格："
							+ price + "<br>" + "订单编号：" + logCode + "<br>"
							+ "支付结果描述：" + showMsg + "<br>").toString();
			DouDiZhuApplicaion.debugLog(resultStr);
		}
	}
}
