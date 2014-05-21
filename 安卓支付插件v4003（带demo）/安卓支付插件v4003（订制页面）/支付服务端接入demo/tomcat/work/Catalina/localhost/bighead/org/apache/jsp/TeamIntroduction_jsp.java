package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.util.*;
import java.io.*;

public final class TeamIntroduction_jsp extends org.apache.jasper.runtime.HttpJspBase
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
      out.write("  \t团队介绍\r\n");
      out.write("</div>\r\n");
      out.write(" \r\n");
      out.write(" \t<p>\r\n");
      out.write(" \t大家好，我们是乐乐，林林，凡凡，鸟鸟，四人组成的小团队，来自杭州，同学+朋友关系，利用业余时间，开发MRP免费软件。\r\n");
      out.write("\t<br/>\r\n");
      out.write("\t<br/>\r\n");
      out.write("\t我们喜欢简单而美好的事物，崇尚淳朴真实的生活态度。就像热爱山林的小鸟，保持开心快乐～\r\n");
      out.write("\t<br/>\r\n");
      out.write("\t<br/>\r\n");
      out.write("\t我们的愿景是：让国产手机用户也能使用优秀的手机软件，充分享受手机娱乐生活~\r\n");
      out.write("\t<br/>\r\n");
      out.write("\t<br/>\r\n");
      out.write("\t<a href=\"MessageBoard.jsp\">我要留言</a>\r\n");
      out.write("\t<br/>\r\n");
      out.write("\t</p>\r\n");
      out.write("\t\r\n");
      out.write("\t<div class=\"title\">\r\n");
      out.write("  \t联系我们\r\n");
      out.write("\t</div>\r\n");
      out.write("\t<div class=\"p\">\r\n");
      out.write("  \t1.我爱大头贴官方QQ群\r\n");
      out.write("\t</div>\r\n");
      out.write("\t官方QQ群1：172418632<br/>\r\n");
      out.write("\t官方QQ群2：172418318<br/>\r\n");
      out.write("\t官方QQ群3：172417886<br/>\r\n");
      out.write("\t官方QQ群4：131590435\r\n");
      out.write("\t\r\n");
      out.write("\t<div class=\"p\">\r\n");
      out.write("  \t2.官方微博\r\n");
      out.write("\t</div>\r\n");
      out.write("\thttp://t.qq.com/llfntech\r\n");
      out.write("\t<br/>\r\n");
      out.write("\thttp://weibo.com/llfntech\r\n");
      out.write("\t\r\n");
      out.write("\t<div class=\"p\">\r\n");
      out.write("  \t3.关注百度贴吧\r\n");
      out.write("\t</div>\r\n");
      out.write("\t“我爱大头贴”\r\n");
      out.write("\t\r\n");
      out.write("\t<div class=\"p\">\r\n");
      out.write("  \t4.邮件地址\r\n");
      out.write("\t</div>\r\n");
      out.write("\tllllffnn@qq.com\r\n");
      out.write("  \t<br/>\r\n");
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
