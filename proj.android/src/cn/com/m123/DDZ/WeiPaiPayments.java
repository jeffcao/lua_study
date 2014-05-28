package cn.com.m123.DDZ;

import com.bx.pay.BXPay;

public class WeiPaiPayments implements PaymentInterface {
	private static BXPay pay;
	@Override
	public void pay(String params) {
		DouDiZhuApplicaion.debugLog("weipai: start pay");
		if (null == pay) {
			pay = new BXPay(DouDiZhu_Lua.INSTANCE);
		}
	}

}
