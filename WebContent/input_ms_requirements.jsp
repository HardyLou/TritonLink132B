<%@page language="java" import="java.sql.*" %>
<% Class.forName("org.postgresql.Driver"); %>
<%
   String URL = "jdbc:postgresql://localhost:5432/cse132b";
   String USERNAME = "postgres";
   String PASSWORD = "hardylou";
   Connection connection = null;
   PreparedStatement pstmt = null;
   ResultSet resultset = null;
%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <title>Graduate Student's Remaining Requirements</title>
        <script type="text/JavaScript"> 
            function handleSelect(form_classes_by_student){
                var selIndex = form_classes_by_student.selected.selectedIndex;
                var selName = form_classes_by_student.selected.options[selIndex].text;
                document.getElementById("ID").value = selName;
            }
        </script> 
    </head>
    <body>

        <%
        try{
            connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            pstmt = connection.prepareStatement(
            "SELECT DISTINCT x.studentid"
            + " FROM graduate x, studentenrollment y"
            + " WHERE"
            + " y.studentid = x.studentid"
            + " AND x.classification = 'MS'");
        } catch (SQLException e){
            e.printStackTrace();
        }

        try{
            resultset = pstmt.executeQuery();
        } catch (SQLException e){
            e.printStackTrace();
        }

        %>

        <h1>Display degree requirements for ALL MS Students</h1>
        <h4>(because there was only one, we didn't limit to just Spring 2009</h4> 
        <div style = "width:100%">
        
            <div style = "float:left; width:20%;">
                <%-- -------- Include menu HTML code -------- --%>
                <jsp:include page="menu.html" />                
            </div>
        
            <div style = "float:left; width:80%;">
                <form name="form_classes_by_student" action="display_ms_requirements.jsp" method="POST">
                        <table border="1">
                        <tbody>
                          <%--  <tr>   
                                <td>Student ID :</td>
                                <td><input value="" name="ID" size="0"></td>
                            </tr>
                            --%>  
                            <tr>   
                                <td>Students enrolled</td>
                                <td><select name="selected" onchange="handleSelect(this.form)"> 
                                    <% while (resultset.next()){ %>
                                    <option>
                                        <%= resultset.getString("studentid") %>
                                    </option>
                                    <% } %>
                                </select></td>
                                <td><input value="" id="ID" name="ID" size="10"></td>
                                <%--   <td><input id="ID" size="10"></td> --%>
                                <td><input type="reset" value="Clear" name="clear">
                                    <input type="submit" value="Submit" name="submit">
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </form>
            </div>
        
        </div>
        
    </body>
</html>
