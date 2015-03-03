<%@page language="java" import="java.sql.*" %>
<% Class.forName("org.postgresql.Driver"); %>

<%@page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <title>Graduate Student Requirements</title>
    </head>
    <body>
        <h1>Display MS student's requirements</h1>
        
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
            PreparedStatement pstmt_classes = null;
            PreparedStatement pstmt_gpa = null;
            ResultSet rs_classes = null;
            ResultSet rs_gpa = null;

            public GradeReport(){
                
                try {
                    connection = DriverManager.getConnection(URL, USERNAME,PASSWORD);
                    
                    pstmt_classes = connection.prepareStatement(
                        "SELECT x.name"
                        + " FROM gradeconversion w, concentration x, class y, classenrollment z"
                        + " WHERE x.reqcourse = y.coursetitle"
                        + " AND y.sectionid = z.sectionid"
                        + " AND z.gradereceived <> 'P'"
                        + " AND z.gradereceived <> 'NP'"
                        + " AND z.gradereceived = w.lettergrade"
                        + " AND z.studentid = ?"
                        + " GROUP BY x.name"
                        + " HAVING SUM(z.units) >= 12"
                        + " AND AVG(w.value) >= 3"
                    ); 
                    pstmt_gpa = connection.prepareStatement(
                        "SELECT DISTINCT x.name, y.coursetitle, z.term"
                        + " FROM concentration x, class y, classenrollment z"
                        + " WHERE x.reqcourse = y.coursetitle"
                        + " AND y.sectionid = z.sectionid"
                        + " AND z.studentid <> ?"
                    ); 
                } catch (SQLException e){
                    e.printStackTrace();
                }

            }

            public ResultSet getClasses(String ID){
                try{
                    pstmt_classes.setString(1, ID);
                    rs_classes = pstmt_classes.executeQuery();
                } catch (SQLException e){
                    e.printStackTrace();
                }

                return rs_classes;
            }
            
            public ResultSet getGPA(String ID){
                try{
                    pstmt_gpa.setString(1, ID);
                    rs_gpa = pstmt_gpa.executeQuery();
                } catch (SQLException e){
                    e.printStackTrace();
                }

                return rs_gpa;
            }
            
        }
        %>
        
        <%
            String studentID = new String();

            if(request.getParameter("ID") != null){
                studentID = request.getParameter("ID");
            }

            GradeReport stdreport = new GradeReport();
            ResultSet classes = stdreport.getClasses(studentID);
            ResultSet gpa = stdreport.getGPA(studentID);
        %>
        <table border="1">
            <tbody>
                <b>Concentration Completed (must have completed 12 units)</b>
                <% while (classes.next()){ %>
                <tr>
                    <td><%= classes.getString("name") %></td>
                    <%--     <td><%= classes.getInt(2) %></td> --%>
                </tr>
                <% } %>
            </tbody>
        </table>
        
        <table border="1">
            <tbody>
                <b>Courses to take to complete concentrations</b>
                <tr>
                    <td>Concentration</td>
                    <td>Course</td>
                    <td>Term</td>
                </tr>
                <% while (gpa.next()){ %>
                <tr>
                    <td><%= gpa.getString("name") %></td>
                    <td><%= gpa.getString("coursetitle") %></td>
                    <td><%= gpa.getString("term") %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        
        </div>
        </div>
    </body>
</html>
