package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.util.*;
import java.io.*;

public final class index_jsp extends org.apache.jasper.runtime.HttpJspBase
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
      out.write("    <meta http-equiv=\"Content-Type\" content=\"application/xhtml+xml; charset=utf-8\"/>\r\n");
      out.write("\t<meta http-equiv=\"pragma\" content=\"no-cache\"/>\r\n");
      out.write("\t<meta http-equiv=\"cache-control\" content=\"no-cache\"/>\r\n");
      out.write("\t<meta http-equiv=\"expires\" content=\"0\"/>    \r\n");
      out.write("\t<meta http-equiv=\"keywords\" content=\"keyword1,keyword2,keyword3\"/>\r\n");
      out.write("\t<meta http-equiv=\"description\" content=\"This is my page\"/>\r\n");
      out.write("\r\n");
      out.write("<style>\r\n");
      out.write("div {}\r\n");
      out.write("a {text-decoration:none;}\r\n");
      out.write("a:hover {color:#CC3300;text-decoration:underline;}\r\n");
      out.write(".title {background-color:#D0EBF9;border:1px #AAD8E9 solid; padding:5px;}\r\n");
      out.write(".title1 {background-color:#D0E7F0;border:1px #AAD8E9 solid; padding:2px;}\r\n");
      out.write(".title2 {border-top:#797A7C 1px solid;padding-top:8px;}\r\n");
      out.write(".bluetitle {background-color:#BFEFFF;}\r\n");
      out.write(".img_center{text-align:center;}\r\n");
      out.write("</style>\r\n");
      out.write("  </head>\r\n");
      out.write("  \r\n");
      out.write("  <body>\r\n");
      out.write("  \t<img src=\"res/title.jpg\"/><br/>\r\n");
      out.write("  \t\r\n");
      out.write(" ");

  	String DOWNLOAD_PHOTO_NAME = " 相框下载 ";
  	String DOWNLOAD_PHOTO_JSP = "DownloadPhoto.jsp";
  	String DOWNLOAD_MRP_NAME = " 软件下载 ";
  	String DOWNLOAD_MRP_JSP = "DownloadMrp.jsp";
  	String FAQ_NAME = " FAQ ";
  	String FAQ_JSP = "FAQ.jsp";
  	
  	String MESSAGE_BOARD_NAME = " 留言本 ";
  	String MESSAGE_BOARD_JSP = "MessageBoard.jsp";
  	String TEAM_INTRODUCTION_NAME = " 团队介绍 ";
  	String TEAM_INTRODUCTION_JSP = "TeamIntroduction.jsp";
  	String QQ_INTRODUCTION_NAME = " QQ群 ";
  	String QQ_INTRODUCTION_JSP = "QQIntroduction.jsp";

      out.write("\r\n");
      out.write("<div class=\"title\">\r\n");
      out.write("  \t<a href=\"");
      out.print(DOWNLOAD_PHOTO_JSP);
      out.write('"');
      out.write('>');
      out.print(DOWNLOAD_PHOTO_NAME);
      out.write("</a>\r\n");
      out.write("  \t |  <a href=\"");
      out.print(DOWNLOAD_MRP_JSP);
      out.write('"');
      out.write('>');
      out.print(DOWNLOAD_MRP_NAME);
      out.write("</a>\r\n");
      out.write("  \t |  <a href=\"");
      out.print(FAQ_JSP);
      out.write('"');
      out.write('>');
      out.print(FAQ_NAME);
      out.write("</a>\r\n");
      out.write("  \t<br/>\r\n");
      out.write("  \t<a href=\"");
      out.print(MESSAGE_BOARD_JSP);
      out.write('"');
      out.write('>');
      out.print(MESSAGE_BOARD_NAME);
      out.write("</a>\r\n");
      out.write("  \t |  <a href=\"");
      out.print(TEAM_INTRODUCTION_JSP);
      out.write('"');
      out.write('>');
      out.print(TEAM_INTRODUCTION_NAME);
      out.write("</a>\r\n");
      out.write("  \t |  <a href=\"");
      out.print(QQ_INTRODUCTION_JSP);
      out.write('"');
      out.write('>');
      out.print(QQ_INTRODUCTION_NAME);
      out.write("</a>\r\n");
      out.write("  \t<br/>\r\n");
      out.write("</div>\r\n");
      out.write("\r\n");
      out.write("  \t<br/>\r\n");
      out.write("  \t欢迎访问我爱大头贴官方网站，<br/>\r\n");
      out.write("  \t乐林凡鸟再次感谢您对我们软件的支持，<br/>\r\n");
      out.write("  \t您的肯定是我们最大的动力！\r\n");
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
