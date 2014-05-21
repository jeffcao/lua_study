package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.util.*;
import java.io.*;

public final class FAQ_jsp extends org.apache.jasper.runtime.HttpJspBase
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
      out.write("  \t常见问题\r\n");
      out.write("</div>\r\n");
      out.write("\r\n");
      out.write("\t<div class=\"p\">\r\n");
      out.write("  \t为什么会白屏？\r\n");
      out.write("\t</div>\r\n");
      out.write("\t部分手机的摄像头驱动我们无法正常调用，导致白屏。我们建议这部分用户先用手机拍好照片，再用美化功能装上相框，一样可以做漂亮的大头贴。\r\n");
      out.write("\t\r\n");
      out.write("\t<div class=\"p\">\r\n");
      out.write("  \t为什么会黑屏？\r\n");
      out.write("\t</div>\r\n");
      out.write("\t内存不够导致。大头贴需要较大内存来合成照片，部分手机如果内存较小则会导致黑屏发生\r\n");
      out.write("\t\r\n");
      out.write("\t<div class=\"p\">\r\n");
      out.write("\t免费相框怎么获取？ \r\n");
      out.write("\t</div>\r\n");
      out.write("\t1、官方网站“llfn.net/bighead”<br/>\r\n");
      out.write("\t2、加入QQ群 <br/>\r\n");
      out.write("\t官方QQ群1：172418632<br/>\r\n");
      out.write("\t官方QQ群2：172418318<br/>\r\n");
      out.write("\t官方QQ群3：172417886<br/>\r\n");
      out.write("\t官方QQ群4：131590435<br/>\r\n");
      out.write("\t关注百度贴吧 “我爱大头贴”<br/>\r\n");
      out.write("\t\r\n");
      out.write("\t<div class=\"p\">\r\n");
      out.write("  \t扩展相框如何使用？\r\n");
      out.write("\t</div>\r\n");
      out.write("\t将下载到的相框（bmp文件）拷贝到【mythroad/我爱大头贴/相框】目录下，重新启动我爱大头贴即可。\r\n");
      out.write("\t\r\n");
      out.write("\t<div class=\"p\">\r\n");
      out.write("  \t自己怎么做相框？\r\n");
      out.write("\t</div>\r\n");
      out.write("\t转化工具和具体的视频教程，我们会在qq群里分享。快来加入大头贴制作的队伍吧，和全国贴迷一起分享快乐！ \r\n");
      out.write("  \t<br/>\r\n");
      out.write("  \t<br/>\r\n");
      out.write("  \t<a href=\"index.jsp\">返回首页</a>\r\n");
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
