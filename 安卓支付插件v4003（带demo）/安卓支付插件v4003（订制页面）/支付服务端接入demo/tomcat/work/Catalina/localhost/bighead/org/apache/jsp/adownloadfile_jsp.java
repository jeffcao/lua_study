package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.util.*;
import java.io.*;
import java.text.SimpleDateFormat;

public final class adownloadfile_jsp extends org.apache.jasper.runtime.HttpJspBase
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
      out.write("\t<head>\r\n");
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
      out.write("  \t数据查看\r\n");
      out.write("</div>\r\n");
      out.write(" \r\n");

String SAVE_MESSAGE_FULL_PATH = "res/message/message.txt";
String STATISTIC_PATH = "logs/";
String SAVE_VISIT_COUNT_NAME = "visitCount.txt";
String SAVE_VISIT_IP_NAME = "visitIp.txt";

String SAVE_MAOPAO_VISIT_COUNT_NAME = "visitCount_maopao.txt";
String SAVE_MAOPAO_VISIT_IP_NAME = "visitIp_maopao.txt";
String SAVE_QQ_VISIT_COUNT_NAME = "visitCount_qq.txt";
String SAVE_QQ_VISIT_IP_NAME = "visitIp_qq.txt";
String SAVE_BAIDU_VISIT_COUNT_NAME = "visitCount_baidu.txt";
String SAVE_BAIDU_VISIT_IP_NAME = "visitIp_baidu.txt";

      out.write("\r\n");
      out.write(" \t<p>\r\n");
      out.write(" \t<a href=\"");
      out.print(SAVE_MESSAGE_FULL_PATH);
      out.write("\">留言查询</a><br/>\r\n");
      out.write(" \t<a href=\"");
      out.print(STATISTIC_PATH + SAVE_VISIT_COUNT_NAME);
      out.write("\">访问量查询</a><br/>\r\n");
      out.write(" \t<a href=\"");
      out.print(STATISTIC_PATH + SAVE_VISIT_IP_NAME);
      out.write("\">访问量详情查询</a><br/><br/>\r\n");
      out.write(" \t\r\n");
      out.write(" \t<a href=\"");
      out.print(STATISTIC_PATH + SAVE_MAOPAO_VISIT_COUNT_NAME);
      out.write("\">冒泡空间访问量查询</a><br/>\r\n");
      out.write(" \t<a href=\"");
      out.print(STATISTIC_PATH + SAVE_MAOPAO_VISIT_IP_NAME);
      out.write("\">冒泡空间访问量详情查询</a><br/><br/>\r\n");
      out.write(" \t\r\n");
      out.write(" \t<a href=\"");
      out.print(STATISTIC_PATH + SAVE_QQ_VISIT_COUNT_NAME);
      out.write("\">QQ空间访问量查询</a><br/>\r\n");
      out.write(" \t<a href=\"");
      out.print(STATISTIC_PATH + SAVE_QQ_VISIT_IP_NAME);
      out.write("\">QQ空间访问量详情查询</a><br/><br/>\r\n");
      out.write(" \t\r\n");
      out.write(" \t<a href=\"");
      out.print(STATISTIC_PATH + SAVE_BAIDU_VISIT_COUNT_NAME);
      out.write("\">百度贴吧访问量查询</a><br/>\r\n");
      out.write(" \t<a href=\"");
      out.print(STATISTIC_PATH + SAVE_BAIDU_VISIT_IP_NAME);
      out.write("\">百度贴吧访问量详情查询</a><br/>\r\n");
      out.write(" \t</p>\r\n");
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
