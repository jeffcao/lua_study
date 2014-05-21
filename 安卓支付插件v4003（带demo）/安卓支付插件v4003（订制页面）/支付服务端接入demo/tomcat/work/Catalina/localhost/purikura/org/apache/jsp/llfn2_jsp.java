package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.util.*;
import java.io.*;

public final class llfn2_jsp extends org.apache.jasper.runtime.HttpJspBase
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
      response.setContentType("text/html; charset=gb2312");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write('\r');
      out.write('\n');
request.setCharacterEncoding("GB2312");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");

String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

      out.write("\r\n");
      out.write("\r\n");
      out.write("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\"> \r\n");
      out.write("<html>\r\n");
      out.write("\r\n");
      out.write("  <head>\r\n");
      out.write("    <base href=\"");
      out.print(basePath);
      out.write("\">\r\n");
      out.write("    \r\n");
      out.write("    <title>My JSP 'index.jsp' starting page</title>\r\n");
      out.write("\t<meta http-equiv=\"pragma\" content=\"no-cache\">\r\n");
      out.write("\t<meta http-equiv=\"cache-control\" content=\"no-cache\">\r\n");
      out.write("\t<meta http-equiv=\"expires\" content=\"0\">    \r\n");
      out.write("\t<meta http-equiv=\"keywords\" content=\"keyword1,keyword2,keyword3\">\r\n");
      out.write("\t<meta http-equiv=\"description\" content=\"This is my page\">\r\n");
      out.write("\t<!--\r\n");
      out.write("\t<link rel=\"stylesheet\" type=\"text/css\" href=\"styles.css\">\r\n");
      out.write("\t-->\r\n");
      out.write("  </head>\r\n");
      out.write("  \r\n");
      out.write("  \r\n");
      out.write("  <body>\r\n");
      out.write("  <img src=\"res/title.jpg\"/><br>\r\n");
      out.write("  \t  \t\r\n");
      out.write(" ");

  	String DOWNLOAD_PHOTO_NAME = "相框下载";
  	String DOWNLOAD_PHOTO_JSP = "DownloadPhoto.jsp";
  	String DOWNLOAD_MRP_NAME = "软件下载";
  	String DOWNLOAD_MRP_JSP = "DownloadMrp.jsp";
  	String FAQ_NAME = "FAQ";
  	String FAQ_JSP = "FAQ.jsp";
  	
  	String MESSAGE_BOARD_NAME = "留言本";
  	String MESSAGE_BOARD_JSP = "MessageBoard.jsp";
  	String TEAM_INTRODUCTION_NAME = "团队介绍";
  	String TEAM_INTRODUCTION_JSP = "TeamIntroduction.jsp";
  	String QQ_INTRODUCTION_NAME = "QQ群";
  	String QQ_INTRODUCTION_JSP = "QQIntroduction.jsp";

      out.write("\r\n");
      out.write("  \t");
      out.print(DOWNLOAD_PHOTO_NAME);
      out.write("\r\n");
      out.write("  \t| <a href=\"");
      out.print(DOWNLOAD_MRP_JSP);
      out.write('"');
      out.write('>');
      out.print(DOWNLOAD_MRP_NAME);
      out.write("</a>\r\n");
      out.write("  \t| <a href=\"");
      out.print(FAQ_JSP);
      out.write('"');
      out.write('>');
      out.print(FAQ_NAME);
      out.write("</a>\r\n");
      out.write("  \t<br>\r\n");
      out.write("  \t<a href=\"");
      out.print(MESSAGE_BOARD_JSP);
      out.write('"');
      out.write('>');
      out.print(MESSAGE_BOARD_NAME);
      out.write("</a>\r\n");
      out.write("  \t| <a href=\"");
      out.print(TEAM_INTRODUCTION_JSP);
      out.write('"');
      out.write('>');
      out.print(TEAM_INTRODUCTION_NAME);
      out.write("</a>\r\n");
      out.write("  \t| <a href=\"");
      out.print(QQ_INTRODUCTION_JSP);
      out.write('"');
      out.write('>');
      out.print(QQ_INTRODUCTION_NAME);
      out.write("</a>\r\n");
      out.write("  \t<br>\r\n");
      out.write("  \t<br>\r\n");
      out.write("  \t我爱大头贴第二期相框<br><br>\r\n");
      out.write(" ");

 String RES_SHOW_PATH = "res/llfn2/show/";
 String RES_DOWNLOAD_PATH = "res/llfn2/download/";
 String resShowPath = application.getRealPath("/") + RES_SHOW_PATH;
 File pathFile = new File(resShowPath);  
 File[] files = pathFile.listFiles();
 String fileName = null;
 
      out.write("\r\n");
      out.write("\r\n");
      out.write(" ");

 for (int i = 0; i < files.length; i++) {
 	fileName = files[i].getName();
 
      out.write("\r\n");
      out.write(" \t<img src=\"");
      out.print(RES_SHOW_PATH + fileName);
      out.write("\"/><br>\r\n");
      out.write(" \t<a href=\"");
      out.print(RES_DOWNLOAD_PATH + fileName);
      out.write('"');
      out.write('>');
      out.print(fileName);
      out.write("</a><br>\r\n");
      out.write(" ");

 }
 
      out.write("\r\n");
      out.write(" \r\n");
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
