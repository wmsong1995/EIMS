<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="com.open.util.MySQLJava" %>
<%@ page import="static java.nio.charset.StandardCharsets.ISO_8859_1" %>
<%@ page import="static java.nio.charset.StandardCharsets.UTF_8" %>
<%@ page import="com.open.util.NoInj" %>
<%
    String sql;
    MySQLJava open = new MySQLJava();
    Connection conn = open.getConnection();
    Cookie cookies[] = request.getCookies(); //读出用户硬盘上的Cookie，并将所有的Cookie放到一个cookie对象数组里面
    Cookie sCookie;
    String svalue = null;
//    String sname = null;

    for (int i = 0; i < cookies.length - 1; i++) {    //用一个循环语句遍历刚才建立的Cookie对象数组
        sCookie = cookies[i]; //取出数组中的一个Cookie对象
        if (sCookie.getName().equals("user_no")) {
//            sname = sCookie.getName(); //取得这个Cookie的名字
            svalue = sCookie.getValue(); //取得这个Cookie的内容
        }
    }
    String user_no = svalue;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <!--[if IE]>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"><![endif]-->
    <title>课程管理系统-教师版</title>
    <meta name="keywords" content=""/>
    <meta name="description" content=""/>
    <meta name="viewport" content="width=device-width">
    <link rel="stylesheet" href="css/templatemo_main.css">

</head>
<body>

<div class="navbar navbar-inverse" role="navigation">
    <div class="navbar-header">
        <div class="logo"><h1>教职工系统</h1></div>
        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="sr-only"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
        </button>
    </div>
</div>
<div class="template-page-wrapper">
    <div class="navbar-collapse collapse templatemo-sidebar">
        <ul class="templatemo-sidebar-menu">
            <li><a href="teacher.jsp?user_no=<%out.println(user_no);%>"><i class="fa fa-home"></i>教师</a></li>
            <li class="sub open">
                <a href="javascript:;">
                    <i class="fa fa-database"></i> 学生信息
                    <div class="pull-right"><span class="caret"></span></div>
                </a>
                <ul class="templatemo-submenu">
                    <li><a href="teacher_view_grade.jsp">查看学生成绩</a></li>
                    <li class="active"><a href="teacher_update_grade.jsp">更改学生成绩</a></li>
                </ul>
            </li>
            <!--     <li class="sub open">
                       <a href="javascript:;">
                         <i class="fa fa-database"></i> 教师信息 <div class="pull-right"><span class="caret"></span></div>
                       </a>
                       <ul class="templatemo-submenu">
                           <li><a href="manager_view_teacher.jsp" >查看教师信息</a></li>
                         <li><a href="manager_add_teacher.jsp">注册/修改教师信息</a></li>
                         <li><a href="manager_update_teacher.jsp">删除教师信息</a></li>
                       </ul>
                     </li>
           -->
            <li class="sub open" id="now">
                <a href="javascript:;">
                    <i class="fa fa-database"></i> 课程信息
                    <div class="pull-right"><span class="caret"></span></div>
                </a>
                <ul class="templatemo-submenu">
                    <li><a href="teacher_view_course.jsp">查看所教课程</a></li>
                    <li><a href="teacher_export_course.jsp">导出课表</a></li>
                </ul>
            </li>
            <li><a href="javascript:;" data-toggle="modal" data-target="#confirmModal"><i class="fa fa-sign-out"></i>Sign
                Out</a></li>
        </ul>
    </div><!--/.navbar-collapse -->

    <div class="templatemo-content-wrapper">
        <div class="templatemo-content">
            <h1>
                <%
                    Statement stmt;
                    ResultSet rs;
                    try {
                        stmt = conn.createStatement();
                        sql = String.format("select * from teacher where Tno='%s'", user_no);
                        sql = NoInj.TransInjection(sql);  // 防止注入
                        rs = stmt.executeQuery(sql);
                        rs.next(); //有毒！
                        out.println(rs.getString("Tname"));
                %>
            </h1>
            <p>本学期课表如下</p>
            <div class="templatemo-panels">
                <div class="row">
                    <div class="col-md-12 col-sm-12 margin-bottom-30">
                        <div class="panel panel-primary">
                            <div class="panel-heading" style="text-align:center"><h1>课程表</h1></div>
                            <div class="panel-body">
                                <table class="table table-striped">
                                    <thead>
                                    <tr>
                                        <th>节数</th>
                                        <th>星期一</th>
                                        <th>星期二</th>
                                        <th>星期三</th>
                                        <th>星期四</th>
                                        <th>星期五</th>
                                        <th>星期六</th>
                                        <th>星期日</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <%
                                        sql = String.format("SELECT * FROM teacher,course where teacher.Tno='%s' and teacher.Tno=course.Tno", user_no);
                                        sql = NoInj.TransInjection(sql);  // 防止注入
                                        rs = stmt.executeQuery(sql);
                                        String name[] = new String[20];
                                        String week[] = new String[20];
                                        String day[] = new String[20];
                                        int j = 0;
                                        while (rs.next()) {
                                            String cname = rs.getString("Cname");
                                            String cweek = rs.getString("Cweek");
                                            String cday = rs.getString("Cday");
//                                            String Addr = new String(rs.getString("Addr").getBytes(ISO_8859_1), UTF_8);
                                            name[j] = cname;
                                            week[j] = cweek;
                                            day[j] = cday;
                                            j++;
                                        }
                                        for (int i = 1; i < 5; i++) {
                                            String ii = i + "";
                                            out.println("<tr>");
                                            out.println("<td>" + ii + "</td>");
                                            for (int k = 1; k < 8; k++) {
                                                String kk = k + "";
                                    %>
                                    <%
                                                    int flag = 1;
                                                    for (int m = 0; m < j; m++) {
                                                        if (week[m].equals(kk) && day[m].equals(ii)) {
                                                            out.println("<td>" + name[m] + "</td>");
                                                            flag = 0;
                                                            break;
                                                        }
                                                    }
                                                    if (flag == 1)
                                                        out.println("<td></td>");
                                                }
                                                out.println("</tr>");
                                            }
                                            rs.close();
                                            stmt.close();
                                            conn.close();
                                        } catch (SQLException e) {
                                            e.printStackTrace();
                                        }
                                    %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal -->
    <div class="modal fade" id="confirmModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
         aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"><span
                            aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                    <h4 class="modal-title" id="myModalLabel">是否注销登录</h4>
                </div>
                <div class="modal-footer">
                    <a href="index.jsp" class="btn btn-primary">是</a>
                    <button type="button" class="btn btn-default" data-dismiss="modal">否</button>
                </div>
            </div>
        </div>
    </div>
    <footer class="templatemo-footer">
        <div class="templatemo-copyright">
            <p>Copyright &copy; College of Information Science and Engineering,Hunan University</p>
        </div>
    </footer>
</div>

<script src="js/jquery.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/Chart.min.js"></script>
<script src="js/templatemo_script.js"></script>
<script type="text/javascript">
    $(document).ready(function () {
        $(".templatemo-sidebar-menu li.sub a").parent().removeClass('open');
    })
</script>
</body>
</html>