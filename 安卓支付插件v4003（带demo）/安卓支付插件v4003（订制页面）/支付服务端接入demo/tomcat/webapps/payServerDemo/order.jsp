<%@page language="java" 
import="java.util.*" 
import="java.security.MessageDigest"
import="java.security.NoSuchAlgorithmException"
import="java.net.URLEncoder"
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.0//EN" "http://www.wapforum.org/DTD/xhtml-mobile10.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

  <head>
			<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=utf-8" />   
			<title>服务端生成订单demo</title>
  </head>
  
  <body>
		<%
			//步骤一：初始化订单参数
			String merchantPasswd = "wap123";	//斯凯分配的商户密码，此处为示例，请不要将“wap123”放到您的程序中去
			String merchantId = "10060";			//斯凯分配的商户号，此处为示例，请不要将“10060”放到您的程序中去
			
			int appId = 100004; 							//斯凯分配的应用编号，此处为示例，请不要将"100004"放到您的程序中去
			String orderId = String.valueOf(System.currentTimeMillis());		//订单号，应保证唯一以便日后核对数据
			
			//后台回调地址，需要进行urlencode，请不要将"http://www.baidu.com/放到您的程序中去
			String notifyAddress = URLEncoder.encode("http://www.demo.com/", "utf-8");
			String appName = "测试程序";  		//应用名称，不需要编码，建议使用中文，以便后台统计数据
			int appVersion = 1006; 						//应用版本，不能含有特殊符号的整数。如：1.0 ，会报非法的appversion
			int price = 200;  								//计费价格，单位：分
			String payMethod = "sms"; 				//设置使用运营商计费还是第三方计费；第三方：3rd   运营商：sms
			String gameType = "1";						//游戏类型，0：单机   1：联网    2：弱联网
			int systemId = 300021;						//系统号，300024：支付中心合作接入 ； 300021：冒泡市场合作接入
			int payType = 3;									//支付类型，3：充值
			String productName = "金币";			//商品名称，不需要编码，建议使用中文
			/*
			 *  .渠道号：若应用在斯凯渠道推广，则选择填写下列预定义值
			 * a.	冒泡市场：1_zhiyifu_
			   b.	冒泡游戏：9_zhiyifu_

			 * 	如果在斯凯以外的渠道推广，以daiji_打头，后面自定义（自定义内容不能含有‘zhiyifu’）
			 */
			String channelId = "_1_zhiyifu_";	//渠道号，方便分渠道统计收入
			

			//三个保留字段提供给CP使用，后台通知时将源数据返回，可以为null
			String reserved1 = "1";
			String reserved2 = "2";
			String reserved3 = URLEncoder.encode("1|=2/3", "utf-8");//含非法字符的需要进行urlencode
			
	    //步骤二：生成签名，
	    /*注：
	     *1、签名参数有序不能调换!!
	     *2、没有出现在订单里的参数，可以不参与签名，如:3个保留字段
	     *3、以后新增加的字段，不再需要参与签名
	     */
	    StringBuffer sb = new StringBuffer();
	    sb.append("merchantId=" + merchantId);
	    sb.append("&appId=" + appId);
	    sb.append("&notifyAddress=" + notifyAddress);
	    sb.append("&appName=" + appName);
	    sb.append("&appVersion=" + appVersion);
	    sb.append("&payType=" + payType);
	    sb.append("&price=" + price);
	    sb.append("&orderId=" + orderId);
	    if(reserved1 != null && !reserved1.equals("")){
	    	 sb.append("&reserved1=" + reserved1);
	    }
	    if(reserved1 != null && !reserved2.equals("")){
	    	 sb.append("&reserved2=" + reserved2);
	    }
	    if(reserved1 != null && !reserved3.equals("")){
	    	 sb.append("&reserved3=" + reserved3);
	    }
	    
	    sb.append("&key=" + merchantPasswd);//最后添加密钥
	    
	    String sigSrc = sb.toString();
	    System.out.println("签名数据：" + sigSrc);			
	    
      String mySign = null;
	    try {
	    			//通过MD5计算出签名
            MessageDigest messageDigest = MessageDigest.getInstance("MD5");
            byte[] b = messageDigest.digest(sigSrc.getBytes("utf-8"));
            
            String HEX_CHARS = "0123456789abcdef";
	    			sb = new StringBuffer();
		        for (byte aB : b) {
		            sb.append(HEX_CHARS.charAt(aB >>> 4 & 0x0F));
		            sb.append(HEX_CHARS.charAt(aB & 0x0F));
		        }
		        mySign = sb.toString();
		        
		        //注意：最后需要转化成大写
		        mySign = mySign.toUpperCase();
      } catch (Exception e) {
          throw new RuntimeException(e);
      }

		 //步骤三：组装订单，订单里的参数无序可以随意调换
	   String orderInfo =  "notifyAddress=" + notifyAddress
	    										+ "&merchantId=" + merchantId
													+ "&appId=" + appId
													+ "&orderId=" + orderId
													+ "&appName=" + appName
													+ "&appVersion=" + appVersion
													+ "&price=" + price
													+ "&payMethod=" + payMethod
													+ "&gameType=" + gameType
													+ "&systemId=" + systemId
													+ "&payType=" + payType
													+ "&productName=" + productName
													+ "&channelId=" + channelId
													
													+ "&reserved1=" + reserved1
													+ "&reserved2=" + reserved2
													+ "&reserved3=" + reserved3
													+ "&merchantSign=" + mySign;
													
													
		

        if("sms".equals(payMethod)) {     
			//payPointNum的值为整数，要和申请xml表里计费点编号相对应
			int payPointNum = 1;
			//短信支付描述，orderDesc里必须把价格写成N.NN 不需要写成数字。在显示时会自动被price替换掉
			String orderDesc = "流畅的操作体验，劲爆的超控性能，无与伦比的超级必杀，化身斩妖除魔的英雄，开启你不平凡的游戏人生！！需花费N.NN元。";
			orderInfo = orderInfo + "&payPointNum=" + payPointNum
								  + "&orderDesc=" + orderDesc;
		}
	
			System.out.println("订单数据：" + orderInfo);										
			out.print(orderInfo);
		%>
  </body>
</html>
