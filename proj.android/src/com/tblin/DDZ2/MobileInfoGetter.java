package com.tblin.DDZ2;

import java.util.HashMap;
import java.util.Map;

import android.content.Context;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.telephony.TelephonyManager;

public class MobileInfoGetter {

	/**
	 * android.permission.READ_PHONE_STATE
	 */
	private Context mContext;
	private TelephonyManager tm;
	private String MAC;

	public MobileInfoGetter(Context context) {
		mContext = context;
		tm = (TelephonyManager) mContext
				.getSystemService(Context.TELEPHONY_SERVICE);
	}

	public String getFingerprint() {
		return Build.FINGERPRINT;
	}

	public String getId() {
		return Build.ID;
	}

	public String getDisplay() {
		return Build.DISPLAY;
	}

	public String getProduct() {
		return Build.PRODUCT;
	}

	public String getDevice() {
		return Build.DEVICE;
	}

	public String getBoard() {
		return Build.BOARD;
	}

	public String getCpu_Abi() {
		return Build.CPU_ABI;
	}

	public String getManufacture() {
		return Build.MANUFACTURER;
	}

	public String getVersion() {
		return Build.VERSION.RELEASE;
	}

	public String getModel() {
		return Build.MODEL;
	}

	public String getBrand() {
		return Build.BRAND;
	}

	public String getImsi() {
		String imsi = tm.getSubscriberId();
		return imsi;
	}

	public String getImei() {
		return tm.getDeviceId();
	}
	
	public String getMobilePossible() {
		return tm.getLine1Number();
	}

	/**
	 * need permission: android.permission.ACCESS_WIFI_STATE
	 * 
	 * @return
	 */
	public String getMac() {
		if (MAC == null) {
			WifiManager mgr = (WifiManager) mContext
					.getSystemService(Context.WIFI_SERVICE);
			WifiInfo info = mgr.getConnectionInfo();
			MAC = info.getMacAddress();
		}
		return MAC != null ? MAC : "00:00:00:00:00:00";
	}

	//"wifi", "mobile:2g", "mobile:3g"
	public String getNetworkType() {
		return NetworkListener.getNetworkType(mContext);
	}
	
	public Map<String, String> getAllInfo() {
		Map<String, String> infos = new HashMap<String, String>();
		infos.put("hw_imei", getImei());
		infos.put("hw_mac", getMac());
		infos.put("hw_imsi", getImsi());
		infos.put("hw_brand", getBrand());
		infos.put("hw_model", getModel());
		infos.put("hw_version", getVersion());
		infos.put("hw_manufacture", getManufacture());
		infos.put("hw_cpu_abi", getCpu_Abi());
		infos.put("hw_board", getBoard());
		infos.put("hw_device", getDevice());
		infos.put("hw_product", getProduct());
		infos.put("hw_display", getDisplay());
		infos.put("hw_id", getId());
		infos.put("hw_fingerprint", getFingerprint());
		//infos.put("hw_mobilepossible", getMobilePossible());
		return infos;
	}
	
}
