<%@page language="java" import="java.sql.*" %>
<% Class.forName("org.postgresql.Driver"); %>

<%@page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <title>Class Conflicts</title>
    </head>
    <body>
        <h1>Display all class conflicts for a student</h1>
        
        <div style = "width:100%">
        
            <div style = "float:left; width:20%;">
                <%-- -------- Include menu HTML code -------- --%>
                <jsp:include page="menu.html" />                
            </div>
        
            <div style = "float:left; width: 80%;">
        
        <%!
        public class ClassRoster {
            String URL = "jdbc:postgresql://localhost:5432/cse132b";
            String USERNAME = "postgres";
            String PASSWORD = "hardylou";

            Connection connection = null;
            PreparedStatement pstmt = null;
            ResultSet resultSet = null;

            public ClassRoster(){
                
                try {
                    connection = DriverManager.getConnection(URL, USERNAME,PASSWORD);
                    pstmt = connection.prepareStatement(
                    	"SELECT DISTINCT b.coursetitle, b2.coursetitle" // use c2.sectionid to test
                        + " FROM ClassEnrollment a, Class b, ClassMeeting c, WeeklyMeeting w, Class b2, ClassMeeting c2, WeeklyMeeting w2"
                        + " WHERE a.studentid = ?"
                        + " AND a.sectionid = b.sectionid"
                        + " AND b.term = 'SP09'"
                        + " AND b.sectionid = c.sectionid"
                        + " AND c.meetingid = w.id"
                        + " AND b2.term = 'SP09'"
                        + " AND b2.sectionid = c2.sectionid"
                        + " AND c2.meetingid = w2.id"
                        //+ " AND w.day = w2.day AND (w.start_time >= w2.end_time OR w.end_time <= w2.start_time)" // class on same day, but no conflict
                        
                        + " AND w.day = w2.day"
                        + " AND ((w.start_time > w2.start_time AND w.start_time < w2.end_time) OR (w.end_time > w2.start_time AND w.end_time < w2.end_time))"
                        );
                } catch (SQLException e){
                    e.printStackTrace();
                }

            }

            public ResultSet getStudents(String ID){
                try{
                    pstmt.setString(1, ID);
                    resultSet = pstmt.executeQuery();
                } catch (SQLException e){
                    e.printStackTrace();
                }

                return resultSet;

            }
        }
        %>
        <%
            String courseTitle = new String();

            if(request.getParameter("ID") != null){
                courseTitle = request.getParameter("ID");
            }

            ClassRoster stdstudents = new ClassRoster();
            ResultSet students = stdstudents.getStudents(courseTitle);
        %>
        <table border="1">
            <tbody>
                <tr>
                    <td>Class Enrolled</td>
                    <td>Conflicts With</td>
                </tr>
                <% while (students.next()){ %>
                <tr>
                    <td><%= students.getString(1) %></td>
                    <td><%= students.getString(2) %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        
        </div>
        </div>
    </body>
</html>
