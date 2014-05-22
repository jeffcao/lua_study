package org.apache.jsp.PhotoFrame.spr320;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.util.*;
import java.io.*;

public final class PhotoFrameForReadAuto_jsp extends org.apache.jasper.runtime.HttpJspBase
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
      out.write("</style>\r\n");
      out.write("  </head>\r\n");
      out.write("  \r\n");
      out.write("  \r\n");
      out.write("  <body>\r\n");
      out.write("<div class=\"title\">\r\n");
      out.write("  \t相框下载 >> SPR240320\r\n");
      out.write("</div>\r\n");
      out.write("\t\r\n");
      out.write("\t<p>\r\n");
      out.write("\t说明：【我爱大头贴】会在冒泡浏览器默认的保存目录下搜索相框。其他浏览器下载，需要手动将相框拷贝到【mythroad/我爱大头贴/相框/】目录\r\n");
      out.write("\t<br/>\r\n");
      out.write("\t\r\n");
      out.write(" ");

 String resPath = request.getParameter("resPath");
 String backJsp = request.getParameter("backJsp");
 String RES_SHOW_PATH = resPath + "show/";
 String RES_DOWNLOAD_PATH = resPath + "download/";
 String READ_FILE_FULL_PATH = application.getRealPath("/") + "PhotoFrame/spr320/" + RES_DOWNLOAD_PATH;
 File pathFile = new File(READ_FILE_FULL_PATH);  
 File[] files = pathFile.listFiles();
 String fileName = null;
 
 String STATISTIC_PATH = "statistics/";
 String STATISTIC_FULL_PATH = application.getRealPath("/") + STATISTIC_PATH;
 String SAVE_VISIT_COUNT_NAME = null;
 String visitCount = null;
 FileInputStream inputStream = null;
 BufferedReader bufferedReader = null;
 
      out.write("\r\n");
      out.write("\t\r\n");
      out.write("\t<p>\r\n");
      out.write(" ");

 for (int i = 0; i < files.length; i++) {
 	fileName = files[i].getName();
 	
 	//获取统计数目
 	SAVE_VISIT_COUNT_NAME = fileName.substring(0,fileName.indexOf(".")) + ".txt";
 	File file = new File(STATISTIC_FULL_PATH + SAVE_VISIT_COUNT_NAME);
 	if(file.exists())//如果文件不存，则建立
	{
	 	inputStream = new FileInputStream(STATISTIC_FULL_PATH + SAVE_VISIT_COUNT_NAME);
		//将字符流转化成字符流对象(字符流对象：以reader或writer结尾的对象)，自动将系统编码转成Unicode编码；
		Reader reader = new InputStreamReader(inputStream);
		//对字符流对象进行再一次包装成读缓存对象
		bufferedReader = new BufferedReader(reader);
					
		//读取数据并添加到StringBuffer对象中
		String stringLine = bufferedReader.readLine();
		visitCount = stringLine;
	}else{
		visitCount = "0";
	}
 
      out.write("\r\n");
      out.write(" \t累计下载【");
      out.print(visitCount);
      out.write("】次<br/>\r\n");
      out.write(" \t<img src=\"");
      out.print(RES_SHOW_PATH + fileName);
      out.write("\" width=\"110\" height=\"147\"/><br/>\r\n");
      out.write(" \t");
      out.print(fileName.substring(0,fileName.indexOf(".")));
      out.write("&nbsp;\r\n");
      out.write(" \t<a href=\"../../DownloadFile.jsp?download_file=");
      out.print("PhotoFrame/spr320/" + RES_DOWNLOAD_PATH + fileName);
      out.write("&file_name=");
      out.print(fileName.substring(0,fileName.indexOf(".")));
      out.write("\">点击下载</a><br/>\r\n");
      out.write("\t<br/>\r\n");
      out.write(" ");

 }
 
      out.write("\r\n");
      out.write(" \t<br/>\r\n");
      out.write(" \t<a href=\"");
      out.print(backJsp);
      out.write("\">返回</a>\r\n");
      out.write(" \t</p>\r\n");
      out.write(" \t\r\n");
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
