using UnityEngine;
using System;
using System.Collections.Generic;

public class CmBillingAndroidDemo : MonoBehaviour
{
	#if UNITY_ANDROID

	void Awake ()
	{
		if (Application.platform == RuntimePlatform.Android)
		{
			CmBillingAndroid.Instance.InitializeApp();
		}
	}

	void Start ()
	{
		//CmBillingAndroidDemo.Billing("001");
	}

	void OnBillingResult(String result)
	{ 
		Debug.Log("BillingResult="+result);
		String[] results = result.Split('|');
		if(CmBillingAndroid.BillingResult.CANCELLED==results[1])
		{
			CmBillingAndroid.Instance.Exit();
		} 
	}
	
	void OnLoginResult(String result)
	{ 
		Debug.Log("LoginResult="+result);
	}

	public static void Billing(String index)
    {
        CmBillingAndroid.Instance.DoBilling(true, false, "001", "", "Main Camera", "OnBillingResult");
    }
	#endif
}
