<%@page language="java" import="java.sql.*" %>
<% Class.forName("org.postgresql.Driver"); %>

<%@page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <title>Student's classes</title>
    </head>
    <body>
        <h1>Display the classes currently taken by student</h1>
        <%!
        public class Studentsclasses {
            String URL = "jdbc:postgresql://localhost:5432/cse132b";
            String USERNAME = "postgres";
            String PASSWORD = "hardylou";

            Connection connection = null;
            PreparedStatement pstmt = null;
            ResultSet resultSet = null;

            public Studentsclasses(){
                
                try {
                    connection = DriverManager.getConnection(URL, USERNAME,PASSWORD);
                    pstmt = connection.prepareStatement(
                        "SELECT a.sectionid, a.coursetitle, a.instructor, a.term, b.grade, b.units"
                        + " FROM class a, classenrollment b"
                        + " WHERE b.studentid = ?"
                        + " AND b.term = 'SP09'"
                        + " AND b.sectionid = a.sectionid");
                } catch (SQLException e){
                    e.printStackTrace();
                }

            }

            public ResultSet getClasses(String ID){
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
            String studentID = new String();

            if(request.getParameter("ID") != null){
                studentID = request.getParameter("ID");
            }

            Studentsclasses stdclasses = new Studentsclasses();
            ResultSet classes = stdclasses.getClasses(studentID);
        %>
        <table border="1">
            <tbody>
                <tr>
                    <td>Section ID</td>
                    <td>Course Title</td>
                    <td>Instructor</td>
                    <td>Term</td>
                    <td>Grade</td>
                    <td>Units</td>
                </tr>
                <% while (classes.next()){ %>
                <tr>
                    <td><%= classes.getString("sectionid") %></td>
                    <td><%= classes.getString("coursetitle") %></td>
                    <td><%= classes.getString("instructor") %></td>
                    <td><%= classes.getString("term") %></td>
                    <td><%= classes.getString("grade") %></td>
                    <td><%= classes.getString("units") %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </body>
</html>
