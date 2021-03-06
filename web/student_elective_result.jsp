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
    String Sno = request.getParameter("Sno");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <!--[if IE]>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"><![endif]-->
    <title>课程管理系统-学生版</title>
    <meta name="keywords" content=""/>
    <meta name="description" content=""/>
    <meta name="viewport" content="width=device-width">
    <link rel="stylesheet" href="css/templatemo_main.css">
    <!--
    Dashboard Template
    http://www.templatemo.com/preview/templatemo_415_dashboard
    -->
</head>
<body>
<div class="navbar navbar-inverse" role="navigation">
    <div class="navbar-header">
        <div class="logo"><h1>学生系统</h1></div>
        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
        </button>
    </div>
</div>
<div class="template-page-wrapper">
    <div class="navbar-collapse collapse templatemo-sidebar">
        <ul class="templatemo-sidebar-menu">
            <li class="active"><a href="student.jsp?user_no=<%out.println(Sno);%>"><i class="fa fa-home"></i>学生</a></li>
            <li class="sub open">
                <a href="javascript:;">
                    <i class="fa fa-database"></i> 选课服务
                    <div class="pull-right"><span class="caret"></span></div>
                </a>
                <ul class="templatemo-submenu">
                    <li><a href="student_select_course.jsp?Sno=<%out.println(Sno);%>">选课</a></li>
                    <li><a href="student_elective_result.jsp?Sno=<%out.println(Sno);%>">选课结果</a></li>
                </ul>
            </li>
            <li class="sub">
                <a href="student_view_classtable.jsp?Sno=<%out.println(Sno);%>">
                    <i class="fa fa-database"></i> 查看课程
                    <div class="pull-right"></div>
                </a>
            </li>
            <li class="sub">
                <a href="student_view_score.jsp?Sno=<%out.println(Sno);%>">
                    <i class="fa fa-database"></i> 查看成绩
                    <div class="pull-right"></div>
                </a>
            </li>

            <li><a href="javascript:;" data-toggle="modal" data-target="#confirmModal"><i class="fa fa-sign-out"></i>Sign
                Out</a></li>
        </ul>
    </div><!--/.navbar-collapse -->

    <div class="templatemo-content-wrapper">
        <div class="templatemo-content">
            <h1>请注意：</h1>
            <p>本系学生只能选择本系开设课程</p>
            <div class="templatemo-panels">
                <div class="row">
                    <div class="col-md-12 col-sm-12 margin-bottom-30">
                        <div class="panel panel-primary">
                            <div class="panel-heading" style="text-align:center"><h1>选课表</h1></div>
                            <div class="panel-body">
                                <%
                                    try {
                                        Statement stmt = conn.createStatement();
                                        sql = String.format("select * from sc,course where sc.cno=course.cno and Sno='%s'", Sno);
                                        sql = NoInj.TransInjection(sql);  // 防止注入
                                        ResultSet rs = stmt.executeQuery(sql);
                                        out.println("<table class='table table-striped'><thead><tr><th>课程号</th><th>课程名</th><th>学分</th><th>课程系别</th><th>教师</th><th>授课星期</th><th>授课时间</th><th>课程容量</th><th>已选人数</th><th>授课地点</th><th>退选课程</th></tr></thead>");
                                        out.println("<tbody>");
                                        Statement stmt1 = conn.createStatement();
                                        ResultSet rs1;
                                        while (rs.next()) {
                                            String tempTno = rs.getString("Tno");
                                            sql = String.format("select * from teacher where Tno='%s'", tempTno);
                                            sql = NoInj.TransInjection(sql);  // 防止注入
                                            rs1 = stmt1.executeQuery(sql);
                                            rs1.next();
                                            String tname = rs1.getString("Tname");

                                            String tempCno = rs.getString("Cno");
                                            sql = String.format("select count(*) from sc where Cno='%s'", tempCno); //选择了这个课程的人数
                                            sql = NoInj.TransInjection(sql);  // 防止注入
                                            rs1 = stmt1.executeQuery(sql);
                                            rs1.next();
                                            out.println(String.format("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td><a href='student_update_course.jsp?Cno=%s&Sno=%s&panduan=cancel'>退选</a></td></tr>", rs.getString("Cno"), rs.getString("Cname"), rs.getString("Credit"), rs.getString("Cdept"), tname, rs.getString("Cweek"), rs.getString("Cday"), rs.getString("Cap"), rs1.getString("count(*)"), rs.getString("Addr"), rs.getString("Cno"), Sno));
                                        }
                                        out.println("</tbody></table>");
                                        stmt.close();
                                        stmt1.close();
                                        conn.close();
                                    } catch (SQLException e) {
                                        e.printStackTrace();
                                    }
                                %>
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