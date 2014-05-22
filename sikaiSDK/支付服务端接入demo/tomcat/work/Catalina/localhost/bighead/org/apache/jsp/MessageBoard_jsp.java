package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.util.*;
import java.io.*;
import java.text.SimpleDateFormat;

public final class MessageBoard_jsp extends org.apache.jasper.runtime.HttpJspBase
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

request.setCharacterEncoding("UTF-8");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");

String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

      out.write("\r\n");
      out.write("\r\n");
      out.write("<!DOCTYPE html PUBLIC \"-//WAPFORUM//DTD XHTML Mobile 1.0//EN\" \"http://www.wapforum.org/DTD/xhtml-mobile10.dtd\">\r\n");
      out.write("<html xmlns=\"http://www.w3.org/1999/xhtml\">\r\n");
      out.write("\r\n");
      out.write("  <head>\r\n");
      out.write("    <title>我爱大头贴</title>\r\n");
      out.write("\t<meta http-equiv=\"Content-Type\" content=\"application/xhtml+xml; charset=utf-8\" />\r\n");
      out.write("\t<meta http-equiv=\"pragma\" content=\"no-cache\"/>\r\n");
      out.write("\t<meta http-equiv=\"cache-control\" content=\"no-cache\"/>\r\n");
      out.write("\t<meta http-equiv=\"expires\" content=\"0\"/>    \r\n");
      out.write("\t<meta http-equiv=\"keywords\" content=\"keyword1,keyword2,keyword3\"/>\r\n");
      out.write("\t<meta http-equiv=\"description\" content=\"This is my page\"/>\r\n");
      out.write("\t\r\n");
      out.write("<!--\r\n");
      out.write("\t用css设置头背景颜色\r\n");
      out.write("-->  \r\n");
      out.write(" <style>\r\n");
      out.write(" a {text-decoration:none;}\r\n");
      out.write(".title {background-color:#D0EBF9;border:1px #AAD8E9 solid; padding:5px;}\r\n");
      out.write(".p {background-color:#EEF8FD;border:1px #AAD8E9 solid; padding:5px;}\r\n");
      out.write("</style>\r\n");
      out.write("  </head>\r\n");
      out.write("  <body>\r\n");
      out.write("<div class=\"title\">\r\n");
      out.write("  \t我要留言\r\n");
      out.write("</div>\r\n");
      out.write(" \t\r\n");
      out.write(" \t<form name=\"test\" method=\"get\" action=\"SaveInput.jsp\" >\r\n");
      out.write("\t<input type=\"text\" name=\"inputinfo\" value=\"\" />\r\n");
      out.write("\t<input type=\"submit\" value=\"提交\" name=\"提交\" onclick=\"javascript:window.location.reload()\"/>\r\n");
      out.write("\t<a href=\"javascript:window.location.reload()\">刷新</a>\r\n");
      out.write("\t<br/>\r\n");
      out.write("\t<br/>\r\n");

String SAVE_MESSAGE_FULL_PATH = application.getRealPath("/") + "res/message/";
SimpleDateFormat dateDf = new SimpleDateFormat("yyyy-MM-dd");
String dateMessageName = dateDf.format(new Date()) + ".txt";
String resPath = SAVE_MESSAGE_FULL_PATH + dateMessageName;



List<String> printList = new LinkedList<String>();
//String filename = request.getRealPath("save.txt");
File file = new File(resPath);
if(file.exists())//如果文件存在，则建立
{		
	//StringBuffer stringBuffer = new StringBuffer();		//字符缓存，用于返回数据
	String stringLine = null;							//读取一行数据返回的指针
	BufferedReader bufferedReader = null;				//读缓冲区，实现整行读写方法
		
		try {
			FileInputStream inputStream = new FileInputStream(file);
			
			//将字符流转化成字符流对象(字符流对象：以reader或writer结尾的对象)，自动将系统编码转成Unicode编码；
			Reader reader = new InputStreamReader(inputStream);
			//对字符流对象进行再一次包装成读缓存对象
			bufferedReader = new BufferedReader(reader);
			
			//读取数据并添加到StringBuffer对象中
			while ((stringLine = bufferedReader.readLine()) != null){
				printList.add(stringLine + "<br>");
				//out.println(stringLine + "<br>");
			}
			
			int listSize = printList.size();
			int count = 0;
			if (listSize > 10){
				count = listSize - 10;
			}
			
			if ((listSize % 2) == 0 && listSize != 0){
				for (int i = listSize - 2; i >= count; i -= 2){
					out.println(printList.get(i));
					out.println(printList.get(i + 1));
				}
			}
			
		} catch (Exception e) {
			out.println("打开文件失败" + e.getMessage());
		}finally{
			try {
				if (bufferedReader != null){
				//关闭对象与数据源的连接
					bufferedReader.close();
				}
			} catch (Exception e2) {
				out.println("关闭文件失败" + e2.getMessage());
			}
		}
}else{
	out.println("欢迎提供宝贵的意见");
}

      out.write("\r\n");
      out.write("\t<br/>\r\n");
      out.write("\t<a href=\"index.jsp\">返回首页</a>\r\n");
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
