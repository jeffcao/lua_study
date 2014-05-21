package org.apache.jsp.PhotoFrame.spr320;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.util.*;
import java.io.*;

public final class PhotoFrameForZhongDu_jsp extends org.apache.jasper.runtime.HttpJspBase
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
      out.write("  \t相框下载 >> 网友贡献\r\n");
      out.write("</div>\r\n");

 String RES_SHOW_PATH = "res/PhotoFrameForZhongDu/show/";
 String RES_DOWNLOAD_PATH = "res/PhotoFrameForZhongDu/download/";
 String showName1 = "画圈圈";
 String downloadName1 = "b1.bmp";
 String showName2 = "简单爱";
 String downloadName2 = "b2.bmp";
 String showName3 = "卡通房子";
 String downloadName3 = "b3.bmp";
 String showName4 = "我的爱";
 String downloadName4 = "b4.bmp";
 String showName5 = "小花花";
 String downloadName5 = "b5.bmp";
 String showName6 = "心中有你";
 String downloadName6 = "b6.bmp";
 
      out.write("\r\n");
      out.write("\t\r\n");
      out.write("\t<p>\r\n");
      out.write("\t说明：【我爱大头贴】会在冒泡浏览器默认的保存目录下搜索相框。其他浏览器下载，需要手动将相框拷贝到【mythroad/我爱大头贴/相框/】目录\r\n");
      out.write("\t<br/>\r\n");
      out.write("\t\r\n");
      out.write(" \t<img src=\"");
      out.print(RES_SHOW_PATH + downloadName1);
      out.write("\"/><br/>\r\n");
      out.write(" \t");
      out.print(showName1);
      out.write("&nbsp;<a href=\"");
      out.print(RES_DOWNLOAD_PATH + downloadName1);
      out.write("\">点击下载</a><br/>\r\n");
      out.write(" \t\r\n");
      out.write(" \t<img src=\"");
      out.print(RES_SHOW_PATH + downloadName2);
      out.write("\"/><br/>\r\n");
      out.write(" \t");
      out.print(showName2);
      out.write("&nbsp;<a href=\"");
      out.print(RES_DOWNLOAD_PATH + downloadName2);
      out.write("\">点击下载</a><br/>\r\n");
      out.write(" \t\r\n");
      out.write(" \t<img src=\"");
      out.print(RES_SHOW_PATH + downloadName3);
      out.write("\"/><br/>\r\n");
      out.write(" \t");
      out.print(showName3);
      out.write("&nbsp;<a href=\"");
      out.print(RES_DOWNLOAD_PATH + downloadName3);
      out.write("\">点击下载</a><br/>\r\n");
      out.write(" \t\r\n");
      out.write(" \t<img src=\"");
      out.print(RES_SHOW_PATH + downloadName4);
      out.write("\"/><br/>\r\n");
      out.write(" \t");
      out.print(showName4);
      out.write("&nbsp;<a href=\"");
      out.print(RES_DOWNLOAD_PATH + downloadName4);
      out.write("\">点击下载</a><br/>\r\n");
      out.write(" \t\r\n");
      out.write(" \t<img src=\"");
      out.print(RES_SHOW_PATH + downloadName5);
      out.write("\"/><br/>\r\n");
      out.write(" \t");
      out.print(showName5);
      out.write("&nbsp;<a href=\"");
      out.print(RES_DOWNLOAD_PATH + downloadName5);
      out.write("\">点击下载</a><br/>\r\n");
      out.write(" \t\r\n");
      out.write(" \t<img src=\"");
      out.print(RES_SHOW_PATH + downloadName6);
      out.write("\"/><br/>\r\n");
      out.write(" \t");
      out.print(showName6);
      out.write("&nbsp;<a href=\"");
      out.print(RES_DOWNLOAD_PATH + downloadName6);
      out.write("\">点击下载</a><br/>\r\n");
      out.write("\t\r\n");
      out.write(" \t<br/>\r\n");
      out.write(" \t<a href=\"DownloadPhotoFrame.jsp\">返回</a>\r\n");
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
