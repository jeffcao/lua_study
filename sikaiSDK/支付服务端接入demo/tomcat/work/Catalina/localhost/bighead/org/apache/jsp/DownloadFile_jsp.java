package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.net.URLEncoder;
import java.net.URLDecoder;
import java.io.*;
import com.llfn.bighead.utils.*;
import java.util.*;
import java.io.*;

public final class DownloadFile_jsp extends org.apache.jasper.runtime.HttpJspBase
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
      out.write("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">\r\n");
      out.write("<html>\r\n");
      out.write("  <head>\r\n");
      out.write("    <base href=\"");
      out.print(basePath);
      out.write("\">\r\n");
      out.write("    \r\n");
      out.write("    <title>我爱大头贴</title>\r\n");
      out.write("\t<meta http-equiv=\"Content-Type\" content=\"application/xhtml+xml; charset=utf-8\" />\r\n");
      out.write("\t<meta http-equiv=\"pragma\" content=\"no-cache\"/>\r\n");
      out.write("\t<meta http-equiv=\"cache-control\" content=\"no-cache\"/>\r\n");
      out.write("\t<meta http-equiv=\"expires\" content=\"0\"/>    \r\n");
      out.write("\t<meta http-equiv=\"keywords\" content=\"keyword1,keyword2,keyword3\"/>\r\n");
      out.write("\t<meta http-equiv=\"description\" content=\"This is my page\"/>\r\n");
      out.write("\r\n");
      out.write("  </head>\r\n");
      out.write("  \r\n");

  String STATISTIC_PATH = "statistics/";
  String STATISTIC_FULL_PATH = application.getRealPath("/") + STATISTIC_PATH;
  String SAVE_VISIT_COUNT_NAME = null;
  long visitCount = 0;
  FileInputStream inputStream = null;
  BufferedReader bufferedReader = null;
  
  String downloadFile = request.getParameter("download_file");
  SAVE_VISIT_COUNT_NAME = request.getParameter("file_name")+".txt";
      
    File dir = new File(STATISTIC_FULL_PATH);
	if (!dir.exists()){;
		dir.mkdirs();
	}
		
	File file = new File(STATISTIC_FULL_PATH + SAVE_VISIT_COUNT_NAME);
	if(!file.exists())//如果文件不存，则建立
	{
		try {
			file.createNewFile();
		}catch (IOException e) {
				  
		}
		visitCount = 1;
		WriteLocalFileUtils.writeFile(STATISTIC_FULL_PATH, SAVE_VISIT_COUNT_NAME, "" + visitCount, false);
			  
	}else{
		try {
			inputStream = new FileInputStream(STATISTIC_FULL_PATH + SAVE_VISIT_COUNT_NAME);
			//将字符流转化成字符流对象(字符流对象：以reader或writer结尾的对象)，自动将系统编码转成Unicode编码；
			Reader reader = new InputStreamReader(inputStream);
			//对字符流对象进行再一次包装成读缓存对象
			bufferedReader = new BufferedReader(reader);
				
			//读取数据并添加到StringBuffer对象中
			String stringLine = bufferedReader.readLine();
			visitCount = Long.valueOf(stringLine);
			if (visitCount >= 0){
				visitCount++;
			}
			
			WriteLocalFileUtils.writeFile(STATISTIC_FULL_PATH, SAVE_VISIT_COUNT_NAME, "" + visitCount, false);
		} catch (Exception e) {
		
		}finally{
			try {
				if (bufferedReader != null){
				//关闭对象与数据源的连接
					bufferedReader.close();
				}
			} catch (Exception e2) {

			}
		}
	}
	  
   //downloadFile.replaceAll("%", "/");
   response.sendRedirect(downloadFile);

      out.write("\r\n");
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
