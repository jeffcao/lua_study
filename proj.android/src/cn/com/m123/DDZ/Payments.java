package cn.com.m123.DDZ;

import org.json.JSONException;
import org.json.JSONObject;

import com.anzhi.pay.utils.AnzhiPayments;

public class Payments {
	
	public static void pay(String type, String params) {
		if (type.equalsIgnoreCase("anzhi")) {
			anzhi_pay(params);
		}
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
			String str = String.format("which:%d\nprice:%f\ndesc:%s\ncallBackInfo:%s", new Object[]{which,price,desc,callBackInfo});
			System.out.println("anzhipay----------------------------\n"+str);
			payments.pay(which, price, desc, callBackInfo);
		} catch(NumberFormatException nfe) {
			nfe.printStackTrace();
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}
	
}
