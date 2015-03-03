<%@page language="java" import="java.sql.*" %>
<% Class.forName("org.postgresql.Driver"); %>

<%@page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <title>Course Grade Distribution</title>
    </head>
    <body>
        <h1>Display information on the distribution of grades in particular courses and by particular professors</h1>
        
        <div style = "width:100%">
        
        <div style = "float:left; width:20%;">
            <%-- -------- Include menu HTML code -------- --%>
            <jsp:include page="menu.html" />                
        </div>
        
        <div style = "float:left; width: 80%;">
        <%!
        public class GradeReport {
            String URL = "jdbc:postgresql://localhost:5432/cse132b";
            String USERNAME = "postgres";
            String PASSWORD = "hardylou";

            Connection connection = null;
            PreparedStatement pstmt_all = null;
            PreparedStatement pstmt_iii = null;
            ResultSet rs_all = null;
            ResultSet rs_iii = null;

            public GradeReport(){
                
                try {
                    connection = DriverManager.getConnection(URL, USERNAME,PASSWORD);
                    
                    pstmt_all = connection.prepareStatement(
                        "SELECT COUNT(CASE WHEN c.gradereceived ='A+' OR c.gradereceived='A' OR c.gradereceived='A-' THEN 1 END) AS numA,"
                              + "COUNT(CASE WHEN c.gradereceived ='B+' OR c.gradereceived='B' OR c.gradereceived='B-' THEN 1 END) AS numB,"
                              + "COUNT(CASE WHEN c.gradereceived ='C+' OR c.gradereceived='C' OR c.gradereceived='C-' THEN 1 END) AS numC,"
                              + "COUNT(CASE WHEN c.gradereceived ='D+' OR c.gradereceived='D' OR c.gradereceived='D-' THEN 1 END) AS numD,"
                              + "COUNT(CASE WHEN c.gradereceived ='F' OR c.gradereceived='P' OR c.gradereceived='NP' THEN 1 END) AS numOther"
                        + " FROM course a, class b, classenrollment c"
                        + " WHERE a.title = ? AND b.instructor = ? AND b.term = ?"
                        + " AND a.title = b.coursetitle"
                        + " AND b.sectionid = c.sectionid");
                    
                    pstmt_iii = connection.prepareStatement(
                    	"SELECT COUNT(CASE WHEN c.gradereceived ='A+' OR c.gradereceived='A' OR c.gradereceived='A-' THEN 1 END) AS numA,"
                              + "COUNT(CASE WHEN c.gradereceived ='B+' OR c.gradereceived='B' OR c.gradereceived='B-' THEN 1 END) AS numB,"
                              + "COUNT(CASE WHEN c.gradereceived ='C+' OR c.gradereceived='C' OR c.gradereceived='C-' THEN 1 END) AS numC,"
                              + "COUNT(CASE WHEN c.gradereceived ='D+' OR c.gradereceived='D' OR c.gradereceived='D-' THEN 1 END) AS numD,"
                              + "COUNT(CASE WHEN c.gradereceived ='F' OR c.gradereceived='P' OR c.gradereceived='NP' THEN 1 END) AS numOther"
                        + " FROM course a, class b, classenrollment c"
                        + " WHERE a.title = ? AND b.instructor = ?"
                        + " AND a.title = b.coursetitle"
                        + " AND b.sectionid = c.sectionid");
                    		
                    
                } catch (SQLException e){
                    e.printStackTrace();
                }

            }

            public ResultSet getDistribution(String TITLE, String INSTRUCTOR, String TERM){
                try{
                    pstmt_all.setString(1, TITLE);
                    pstmt_all.setString(2, INSTRUCTOR);
                    pstmt_all.setString(3, TERM);

                    rs_all = pstmt_all.executeQuery();
                } catch (SQLException e){
                    e.printStackTrace();
                }

                return rs_all;
            }
            
            public ResultSet getDistribution(String TITLE, String INSTRUCTOR){
                try{
                    pstmt_iii.setString(1, TITLE);
                    pstmt_iii.setString(2, INSTRUCTOR);

                    rs_iii = pstmt_iii.executeQuery();
                } catch (SQLException e){
                    e.printStackTrace();
                }

                return rs_iii;
            }

            
        }
        %>
        
        <%
            String courseTitle = new String();
            String classInstructor = new String();
            String classTerm = new String();

            //if (request.getParameter("TITLE") != null) {
                courseTitle = request.getParameter("TITLE");
            //}
            
            //if (request.getParameter("INSTRUCTOR") != null) {
                classInstructor = request.getParameter("INSTRUCTOR");
            //}
            
            //if (request.getParameter("TERM") != null) {
                classTerm = request.getParameter("TERM");
            //}

            GradeReport stdreport = new GradeReport();
            ResultSet part_ii = stdreport.getDistribution(courseTitle, classInstructor, classTerm);
            ResultSet part_iii = stdreport.getDistribution(courseTitle, classInstructor);
        %>
        <table border="1">
            <tbody>
                <tr>
                    <td>A</td>
                    <td>B</td>
                    <td>C</td>
                    <td>D</td>
                    <td>Other</td>
                </tr>
                <% while (part_ii.next()){ %>
                <tr>
                    <td><%= part_ii.getInt("numA") %></td>
                    <td><%= part_ii.getInt("numB") %></td>
                    <td><%= part_ii.getInt("numC") %></td>
                    <td><%= part_ii.getInt("numD") %></td>
                    <td><%= part_ii.getInt("numOther") %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        
        <table border="1">
            <tbody>
                <tr>
                    <td>A</td>
                    <td>B</td>
                    <td>C</td>
                    <td>D</td>
                    <td>Other</td>
                </tr>
                <% while (part_iii.next()){ %>
                <tr>
                    <td><%= part_iii.getInt("numA") %></td>
                    <td><%= part_iii.getInt("numB") %></td>
                    <td><%= part_iii.getInt("numC") %></td>
                    <td><%= part_iii.getInt("numD") %></td>
                    <td><%= part_iii.getInt("numOther") %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        
        
        </div>
        </div>
    </body>
</html>