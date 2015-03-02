<%@page language="java" import="java.sql.*" %>
<% Class.forName("org.postgresql.Driver"); %>

<%@page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <title>Class Roster</title>
    </head>
    <body>
        <h1>Display all students that currently taking or have taken the class.</h1>
        
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
                        "SELECT b.studentid, s.firstname, s.middlename, s.lastname, b.grade, b.units"
                        + " FROM class a, classenrollment b, course c, student s"
                        + " WHERE c.title = ?"
                        + " AND a.coursetitle = c.title"
                        + " AND b.sectionid = a.sectionid"
                        + " AND s.id = b.studentid");
                } catch (SQLException e){
                    e.printStackTrace();
                }

            }

            public ResultSet getStudents(String TITLE){
                try{
                    pstmt.setString(1, TITLE);
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

            if(request.getParameter("TITLE") != null){
                courseTitle = request.getParameter("TITLE");
            }

            ClassRoster stdstudents = new ClassRoster();
            ResultSet students = stdstudents.getStudents(courseTitle);
        %>
        <table border="1">
            <tbody>
                <tr>
                    <td>Student ID</td>
                    <td>First Name</td>
                    <td>Middle Name</td>
                    <td>Last Name</td>
                    <td>Grade Option</td>
                    <td>Units</td>
                </tr>
                <% while (students.next()){ %>
                <tr>
                    <td><%= students.getString("studentid") %></td>
                    <td><%= students.getString("firstname") %></td>
                    <td><%= students.getString("middlename") %></td>
                    <td><%= students.getString("lastname") %></td>
                    <td><%= students.getString("grade") %></td>
                    <td><%= students.getString("units") %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        
        </div>
        </div>
    </body>
</html>
