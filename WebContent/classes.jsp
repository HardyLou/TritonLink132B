<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
<title>Classes</title>
</head>

<body>
    <table border="1">
        <tr>
            <td valign="top">
                <%-- -------- Include menu HTML code -------- --%>
                <jsp:include page="menu.html" />
            </td>
            <td>

            <%-- Set the scripting language to Java and --%>
            <%-- Import the java.sql package --%>
            <%@ page language="java" import="java.sql.*" %>
    
            <%-- -------- Open Connection Code -------- --%>
            <%
                try {
                    // Load PostGreSQL Driver class file
                    Class.forName("org.postgresql.Driver");
    
                    // Make a connection to the datasource "cse132b"
                    Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:1328/cse132b", "postgres", "hardylou");
            %>

            <%-- -------- INSERT Code -------- --%>
            <%
                    String action = request.getParameter("action");
                    // Check if an insertion is requested
                    if (action != null && action.equals("insert")) {
                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // INSERT the student attributes INTO the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO Class VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
 
                        pstmt.setString(1, request.getParameter("NUMBER"));
                        pstmt.setString(2, request.getParameter("DATE"));
                        pstmt.setString(3, request.getParameter("TITLE"));
                        pstmt.setInt(
                            4, Integer.parseInt(request.getParameter("SECTIONID")));
                        pstmt.setString(5, request.getParameter("INSTRUCTOR"));
                        pstmt.setInt(
                            6, Integer.parseInt(request.getParameter("LIMIT")));
                        pstmt.setInt(
                            7, Integer.parseInt(request.getParameter("ENROLLED")));
                        pstmt.setInt(
                            8, Integer.parseInt(request.getParameter("WAITLIST")));
                        int rowCount = pstmt.executeUpdate();
                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- UPDATE Code -------- --%>
            <%
                    // Check if an update is requested
                    if (action != null && action.equals("update")) {
                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // UPDATE the student attributes in the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE Class SET NUMBER = ?, DATE = ?, " +
                            "TITLE = ?, INSTRUCTOR = ?, LIMIT = ?, ENROLLED =?, WAITLIST = ? WHERE SECTIONID = ?");
                        pstmt.setString(1, request.getParameter("NUMBER"));
                        pstmt.setString(2, request.getParameter("DATE"));
                        pstmt.setString(3, request.getParameter("TITLE"));
                        pstmt.setString(4, request.getParameter("INSTRUCTOR"));
                        pstmt.setInt(
                            5, Integer.parseInt(request.getParameter("LIMIT")));
                        pstmt.setInt(
                            6, Integer.parseInt(request.getParameter("ENROLLED")));
                        pstmt.setInt(
                            7, Integer.parseInt(request.getParameter("WAITLIST")));
                        pstmt.setInt(
                            8, Integer.parseInt(request.getParameter("SECTIONID")));
                        int rowCount = pstmt.executeUpdate();
                        // Commit transaction
                         conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- DELETE Code -------- --%>
            <%
                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {
                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // DELETE the student FROM the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "DELETE FROM Class WHERE SECTIONID = ?");
                        pstmt.setInt(
                            1, Integer.parseInt(request.getParameter("SECTIONID")));
                        int rowCount = pstmt.executeUpdate();
                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                    // Create the statement
                    Statement statement = conn.createStatement();
                    // Use the created statement to SELECT
                    // the student attributes FROM the Student table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM Class");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Course #</th>
                        <th>Qtr/Year</th>
                        <th>Title</th>
                        <th>Section ID</th>
                        <th>Prof. Last Name</th>
                        <th>Seat Limit</th>
                        <th>Enrolled</th>
                        <th>Waitlist</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="classes.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="NUMBER" size="10"></th>
                            <th><input value="" name="DATE" size="10"></th>
                            <th><input value="" name="TITLE" size="15"></th>
                            <th><input value="" name="SECTIONID" size="15"></th>
                            <th><input value="" name="INSTRUCTOR" size="20"></th>
                            <th><input value="" name="LIMIT" size="15"></th>
                            <th><input value="" name="ENROLLED" size="15"></th>
                            <th><input value="" name="WAITLIST" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="classes.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the course number --%>
                            <td>
                                <input value="<%= rs.getString("NUMBER") %>" 
                                    name="NUMBER" size="10">
                            </td>
    
                            <%-- Get the quarter and year --%>
                            <td>
                                <input value="<%= rs.getString("DATE") %>" 
                                    name="DATE" size="10">
                            </td>
    
                            <%-- Get the course title --%>
                            <td>
                                <input value="<%= rs.getString("TITLE") %>"
                                    name="TITLE" size="15">
                            </td>
    
                            <%-- Get the section ID --%>
                            <td>
                                <input value="<%= rs.getInt("SECTIONID") %>" 
                                    name="SECTIONID" size="15">
                            </td>
    
                            <%-- Get the Instructor's name --%>
                            <td>
                                <input value="<%= rs.getString("INSTRUCTOR") %>" 
                                    name="INSTRUCTOR" size="20">
                            </td>

                            <%-- Get the enrollment limit --%>
                            <td>
                                <input value="<%= rs.getInt("LIMIT") %>" 
                                    name="LIMIT" size="15">
                            </td>

                            <%-- Get the enrolled --%>
                            <td>
                                <input value="<%= rs.getInt("ENROLLED") %>" 
                                    name="ENROLLED" size="15">
                            </td>

                            <%-- Get waitlist --%>
                            <td>
                                <input value="<%= rs.getInt("WAITLIST") %>" 
                                    name="WAITLIST" size="15">
                            </td>
    
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="classes.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getInt("SECTIONID") %>" name="SECTIONID">
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Delete">
                            </td>
                        </form>
                    </tr>
            <%
                    }
            %>

            <%-- -------- Close Connection Code -------- --%>
            <%
                    // Close the ResultSet
                    rs.close();
    
                    // Close the Statement
                    statement.close();
    
                    // Close the Connection
                    conn.close();
                } catch (SQLException sqle) {
                    out.println(sqle.getMessage());
                } catch (Exception e) {
                    out.println(e.getMessage());
                }
            %>
                </table>
            </td>
        </tr>
    </table>
</body>

</html>