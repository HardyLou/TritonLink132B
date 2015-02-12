<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
<title>Course Enrollment</title>
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
                            "INSERT INTO Courseenrollment VALUES (?, ?, ?, ?, ?)");
 
                        pstmt.setString(1, request.getParameter("ID"));
                        pstmt.setString(2, request.getParameter("NUMBER"));
                        pstmt.setInt(
                            3, Integer.parseInt(request.getParameter("SECTIONID")));
                        pstmt.setInt(
                            4, Integer.parseInt(request.getParameter("UNIT")));
                        pstmt.setInt(
                            5, Integer.parseInt(request.getParameter("ENTRY")));
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
                            "UPDATE Courseenrollment SET ID = ?, NUMBER = ?, " +
                            "SECTIONID = ?, UNIT = ? WHERE ENTRY = ?");
                        pstmt.setString(1, request.getParameter("ID"));
                        pstmt.setString(2, request.getParameter("NUMBER"));
                        pstmt.setInt(
                            3, Integer.parseInt(request.getParameter("SECTIONID")));
                        pstmt.setInt(
                            4, Integer.parseInt(request.getParameter("UNIT")));
                        pstmt.setInt(
                            5, Integer.parseInt(request.getParameter("ENTRY")));
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
                            "DELETE FROM Courseenrollment WHERE ENTRY = ?");
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
                        ("SELECT * FROM Courseenrollment");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Student ID</th>
                        <th>Course #</th>
                        <th>Section ID</th>
                        <th>Units</th>
                        <th>Entry</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="courseenrollment.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="ID" size="15"></th>
                            <th><input value="" name="NUMBER" size="15"></th>
                            <th><input value="" name="SECTIONID" size="15"></th>
                            <th><input value="" name="UNIT" size="15"></th>
                            <th><input value="" name="ENTRY" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="courseenrollment.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the ID --%>
                            <td>
                                <input value="<%= rs.getString("ID") %>" 
                                    name="ID" size="15">
                            </td>
    
                            <%-- Get the course number --%>
                            <td>
                                <input value="<%= rs.getString("NUMBER") %>"
                                    name="NUMBER" size="15">
                            </td>
    
                            <%-- Get the section ID --%>
                            <td>
                                <input value="<%= rs.getInt("SECTIONID") %>" 
                                    name="SECTIONID" size="15">
                            </td>
    
                            <%-- Get the units --%>
                            <td>
                                <input value="<%= rs.getInt("UNIT") %>" 
                                    name="UNIT" size="15">
                            </td>
    
                            <%-- Get the Entry number --%>
                            <td>
                                <input value="<%= rs.getInt("ENTRY") %>" 
                                    name="ENTRY" size="15">
                            </td>
    
                            <%-- Button 
                            <td>
                                <input type="submit" value="Update">
                            </td>--%>
                        </form>
                        <form action="courseenrollment.jsp" method="get">
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