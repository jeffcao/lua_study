<%@page language="java" 
import="java.util.*" 
import="java.security.MessageDigest"
import="java.security.NoSuchAlgorithmException"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.0//EN" "http://www.wapforum.org/DTD/xhtml-mobile10.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

  <head>
			<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=utf-8" />   
			<title>服务端处理支付回调demo</title>
  </head>
  
  <body>
		<%
			//步骤一：校验签名
			/*
			 *获取通知数据
			 *例：orderId=331229&cardType=15&skyId=405227121&resultCode=0&payNum=31207121453535990009&realAmount=8636&payTime=20120712030129&failure=0&signMsg=C1A98A661EDAE6C12521884DAC26F327
			 */
			final String queryString = request.getQueryString();
			/*
			 *截取签名
			 *例：C1A98A661EDAE6C12521884DAC26F327
			 */
			String signMsg = queryString.substring(queryString.lastIndexOf("&signMsg=") + "&signMsg=".length());
			/**
			 *截取剩余需要校验签名的信息
			 *例：orderId=331229&skyId=405227121&resultCode=0&payNum=31207121453535990009&cardType=15&realAmount=8636&payTime=20120712030129&failure=0
			 */
	        String signSource = queryString.substring(0, queryString.lastIndexOf("&signMsg="));
	    
			 //指易付分配的商户密钥，程序中请不要使用“wap123”
		   String zhifuyiAppKey="wap123";	
	    
			 /**
			 *组装签名信息
			 *例：orderId=331229&skyId=405227121&resultCode=0&payNum=31207121453535990009&cardType=15&realAmount=8636&payTime=20120712030129&failure=0&key=wap123
			 */
			 signSource = signSource+"&key="+zhifuyiAppKey;
		 
			 String mySign = null;
				try {
							//通过MD5计算出签名
					MessageDigest messageDigest = MessageDigest.getInstance("MD5");
					byte[] b = messageDigest.digest(signSource.getBytes("utf-8"));
					
					String HEX_CHARS = "0123456789abcdef";
							StringBuffer sb = new StringBuffer();
						for (byte aB : b) {
							sb.append(HEX_CHARS.charAt(aB >>> 4 & 0x0F));
							sb.append(HEX_CHARS.charAt(aB & 0x0F));
						}
						mySign = sb.toString();
						
						//注意：最后需要转化成大写再进行比较
						mySign = mySign.toUpperCase();
			  } catch (Exception e) {
				  throw new RuntimeException(e);
			  }
      
			//签名比较
			if (!signMsg.equals(mySign)) {
				  //校验签名失败
						out.print("result=1");
						return;
				}
			
			//步骤二：解析订单参数，进行相关业务处理，如果处理时间较长，建议新建一个线程来处理
			new Thread(new Runnable() {
					@Override
					public void run() {
						// TODO Auto-generated method stub
						
						Map<String, String> retMap = null;
						String[] keyValues = queryString.split("&|=");
						retMap = new HashMap<String, String>();
						for (int i = 0; i < keyValues.length; i = i + 2) {
								retMap.put(keyValues[i], keyValues[i+1]);
						}
						//打印成功支付金额，其他通知参数见文档，
						System.out.println("成功支付金额：" + retMap.get("realAmount") + "分");
					}
			}).start();

	    //最后的发放道具以realAmount为准，不管failure为何值
		
		//步骤三：正常响应（如果步骤二耗时较长，考虑跟步骤三对调，以免有不必要的重复通知）
		/**
		 *成功处理的订单，一定要返回"result=0"！！！！
		 *斯凯只有收到result=0的回应才认为此笔订单交易成功，否则都会再次重复通知，
		 *直到达到5次或其配置的最大次数；
		 *返回result=1的情况主要发生在：
		 *校验签名失败，CP方暂时无法处理支付结果保存，数据库异常，系统异常等
		 */
		out.print("result=0");
		%>
  </body>
</html>
