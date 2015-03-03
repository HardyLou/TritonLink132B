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
        <h1>Display the requirements needed by student</h1>
        
        <div style = "width:100%">
        
            <div style = "float:left; width:20%;">
                <%-- -------- Include menu HTML code -------- --%>
                <jsp:include page="menu.html" />                
            </div>
        
            <div style = "float:left; width: 80%;">
        
        <%!
        public class Studentsclasses {
            String URL = "jdbc:postgresql://localhost:5432/cse132b";
            String USERNAME = "postgres";
            String PASSWORD = "hardylou";

            Connection connection = null;
            PreparedStatement pstmt = null;
            PreparedStatement pstmt2 = null;
            ResultSet resultSet = null;
            ResultSet resultSet2 = null;

            public Studentsclasses(){
                
                try {
                    connection = DriverManager.getConnection(URL, USERNAME,PASSWORD);
                    pstmt = connection.prepareStatement(
                        " SELECT DISTINCT x.degree, y.unitsreq, z.lowerdivunits, z.upperdivunits"
                        + " FROM undergraduate x, degree y, degreecategory z"
                        + " WHERE x.studentid = ?"
                        + " AND x.degree = y.id"
                        + " AND x.degree = z.degreeid"
                    );
                    pstmt2 = connection.prepareStatement(
                        " SELECT SUM(a.units) FROM classenrollment a WHERE a.studentid = ?"
                    );
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

            public ResultSet getUnits(String ID){
                try{
                    pstmt2.setString(1, ID);
                    resultSet2 = pstmt2.executeQuery();
                } catch (SQLException e){
                    e.printStackTrace();
                }

                return resultSet2;

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
            ResultSet classes2 = stdclasses.getUnits(studentID);
        %>
        <table border="1">
            <tbody>
                <tr>
                    <td>Student's Degree</td>
                    <td>Units required</td>
                    <td>Lower Division Units</td>
                    <td>Upper Division Units</td>
                    <td>Units Taken</td>
                </tr>
                <tr>
                <% while (classes.next()){ %>
                    <td><%= classes.getString("degree") %></td>
                    <td><%= classes.getString("unitsreq") %></td>
                    <td><%= classes.getString("lowerdivunits") %></td>
                    <td><%= classes.getString("upperdivunits") %></td>
                <% } %>
                <% while (classes2.next()){ %>
                    <td><%= classes2.getInt(1) %></td>
                <% } %>
                </tr>
            </tbody>
        </table>
        
        </div>
        </div>
    </body>
</html>
