<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Class Enrollment</title>
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
                    Connection conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/cse132b", "postgres", "hardylou");
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
                            "INSERT INTO ClassEnrollment VALUES (?, ?, ?, ?, ?, ?, ?)");
 
                        pstmt.setInt(
                                1, Integer.parseInt(request.getParameter("ENTRY")));
                        pstmt.setString(2, request.getParameter("STUDENTID"));
                        pstmt.setInt(
                                3, Integer.parseInt(request.getParameter("SECTIONID")));
                        pstmt.setString(4, request.getParameter("TERM"));
                        pstmt.setString(5, request.getParameter("GRADE"));
                        pstmt.setInt(
                                6, Integer.parseInt(request.getParameter("UNITS")));
                        pstmt.setString(7, request.getParameter("GRADERECEIVED"));
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
                            "UPDATE ClassEnrollment SET STUDENTID = ?, SECTIONID = ?," +
                            "TERM = ?, GRADE = ?, UNITS = ?, GRADERECEIVED = ? WHERE ENTRY = ?");
                        pstmt.setString(1, request.getParameter("STUDENTID"));
                        pstmt.setInt(
                                2, Integer.parseInt(request.getParameter("SECTIONID")));
                        pstmt.setString(3, request.getParameter("TERM"));                        
                        pstmt.setString(4, request.getParameter("GRADE"));
                        pstmt.setInt(
                                5, Integer.parseInt(request.getParameter("UNITS")));
                        pstmt.setString(6, request.getParameter("GRADERECEIVED"));
                        pstmt.setInt(
                                7, Integer.parseInt(request.getParameter("ENTRY")));
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
                            "DELETE FROM ClassEnrollment WHERE ENTRY = ?");

                        pstmt.setInt(
                        		1, Integer.parseInt(request.getParameter("ENTRY")));
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
                        ("SELECT * FROM ClassEnrollment");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Entry</th>
                        <th>Student ID</th>
                        <th>Section ID</th>
                        <th>Term</th>
                        <th>Grade</th>
                        <th>Units</th>
                        <th>Grade Received</th>
                    </tr>
                    <tr>
                        <form action="class_enrollment.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="ENTRY" size="5"></th>
                            <th><input value="" name="STUDENTID" size="10"></th>
                            <th><input value="" name="SECTIONID" size="10"></th>
                            <th><input value="" name="TERM" size="5"></th>
                            <th><input value="" name="GRADE" size="5"></th>
                            <th><input value="" name="UNITS" size="5"></th>
                            <th><input value="" name="GRADERECEIVED" size="5"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="class_enrollment.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the ID --%>
                            <td>
                                <input value="<%= rs.getInt("ENTRY") %>" 
                                    name="ENTRY" size="5">
                            </td>

                            <%-- Get the SSN, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("STUDENTID") %>" 
                                    name="STUDENTID" size="10">
                            </td>
    
                            <%-- Get the ID --%>
                            <td>
                                <input value="<%= rs.getInt("SECTIONID") %>" 
                                    name="SECTIONID" size="10">
                            </td>
                            
                            <%-- Get the SSN, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("TERM") %>" 
                                    name="TERM" size="5">
                            </td>
                            
                            <%-- Get the SSN, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("GRADE") %>" 
                                    name="GRADE" size="5">
                            </td>
                            
                            <%-- Get the SSN, which is a number --%>
                            <td>
                                <input value="<%= rs.getInt("UNITS") %>" 
                                    name="UNITS" size="5">
                            </td>
                            
                            <%-- Get the SSN, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("GRADERECEIVED") %>" 
                                    name="GRADERECEIVED" size="5">
                            </td>
    
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="class_enrollment.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getInt("ENTRY") %>" name="ENTRY">
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