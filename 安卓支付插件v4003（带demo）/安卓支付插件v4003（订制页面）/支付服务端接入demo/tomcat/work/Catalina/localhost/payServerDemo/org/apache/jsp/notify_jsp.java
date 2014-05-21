package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.util.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public final class notify_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List _jspx_dependants;

  private javax.el.ExpressionFactory _el_expressionfactory;
  private org.apache.AnnotationProcessor _jsp_annotationprocessor;

  public Object getDependants() {
    return _jspx_dependants;
  }

  public void _jspInit() {
    _el_expressionfactory = _jspxFactory.getJspApplicationContext(getServletConfig().getServletContext()).getExpressionFactory();
    _jsp_annotationprocessor = (org.apache.AnnotationProcessor) getServletConfig().getServletContext().getAttribute(org.apache.AnnotationProcessor.class.getName());
  }

  public void _jspDestroy() {
  }

  public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException {

    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    JspWriter out = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;


    try {
      response.setContentType("text/html;charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write("\r\n");
      out.write("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">\r\n");
      out.write("\r\n");
      out.write("<!DOCTYPE html PUBLIC \"-//WAPFORUM//DTD XHTML Mobile 1.0//EN\" \"http://www.wapforum.org/DTD/xhtml-mobile10.dtd\">\r\n");
      out.write("<html xmlns=\"http://www.w3.org/1999/xhtml\">\r\n");
      out.write("\r\n");
      out.write("  <head>\r\n");
      out.write("\t\t\t<meta http-equiv=\"Content-Type\" content=\"application/xhtml+xml; charset=utf-8\" />   \r\n");
      out.write("\t\t\t<title>服务端处理支付回调demo</title>\r\n");
      out.write("  </head>\r\n");
      out.write("  \r\n");
      out.write("  <body>\r\n");
      out.write("\t\t");

			//步骤一：校验签名
			/*
			 *获取通知数据
			 *例：orderId=331229&skyId=405227121&resultCode=0&payNum=31207121453535990009&cardType=15&realAmount=8636&payTime=20120712030129&failure=0&signMsg=C1A98A661EDAE6C12521884DAC26F327
			 */
			String queryString = request.getQueryString();
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
			
			//步骤二：解析订单参数，进行相关业务处理
			Map<String, String> retMap = null;
			String[] keyValues = queryString.split("&|=");
			retMap = new HashMap<String, String>();
			for (int i = 0; i < keyValues.length; i = i + 2) {
					retMap.put(keyValues[i], keyValues[i+1]);
			}
			//打印成功支付金额，其他通知参数见文档
			System.out.println("成功支付金额：" + retMap.get("realAmount") + "分");
			
			//步骤三：正常响应（如果步骤二耗时较长，考虑跟步骤三对调，以免有不必要的重复通知）
			/**
			 *成功处理的订单，一定要返回"result=0"！！！！
			 *斯凯只有收到result=0的回应才认为此笔订单交易成功，否则都会再次重复通知，
			 *直到达到5次或其配置的最大次数；
			 *返回result=1的情况主要发生在：
			 *校验签名失败，CP方暂时无法处理支付结果保存，数据库异常，系统异常等
			 */
			out.print("result=0");
		
      out.write("\r\n");
      out.write("  </body>\r\n");
      out.write("</html>\r\n");
    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          try { out.clearBuffer(); } catch (java.io.IOException e) {}
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
