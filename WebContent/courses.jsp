<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
<title>Courses</title>
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
                            "INSERT INTO Course VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
 
                        pstmt.setString(1, request.getParameter("NUMBER"));
                        pstmt.setString(2, request.getParameter("PREVNUMBER"));
                        pstmt.setString(3, request.getParameter("DEPARTMENT"));
                        pstmt.setString(4, request.getParameter("GRADE"));
                        pstmt.setString(5, request.getParameter("LAB"));   
                        pstmt.setString(6, request.getParameter("PREREQUISITE"));
                        pstmt.setInt(
                            7, Integer.parseInt(request.getParameter("UNITFROM")));
                        pstmt.setInt(
                            8, Integer.parseInt(request.getParameter("UNITTO")));
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
                            "UPDATE Course SET PREVNUMBER = ?, " +
                            "DEPARTMENT = ?, GRADE = ?, LAB = ?, PREREQUISITE = ?, UNITFROM = ?, UNITTO = ? WHERE NUMBER = ?");
                        pstmt.setString(1, request.getParameter("PREVNUMBER"));
                        pstmt.setString(2, request.getParameter("DEPARTMENT"));
                        pstmt.setString(3, request.getParameter("GRADE"));
                        pstmt.setString(4, request.getParameter("LAB"));
                        pstmt.setString(5, request.getParameter("PREREQUISITE"));
                        pstmt.setInt(
                            6, Integer.parseInt(request.getParameter("UNITFROM")));
                        pstmt.setInt(
                            7, Integer.parseInt(request.getParameter("UNITTO")));
                        pstmt.setString(8, request.getParameter("NUMBER"));
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
                            "DELETE FROM Course WHERE NUMBER = ?");
                        pstmt.setString(1, request.getParameter("NUMBER"));
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
                        ("SELECT * FROM Course");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Current Course #</th>
                        <th>Previous Course #</th>
                        <th>Department</th>
                        <th>Grade Option</th>
                        <th>Lab Req</th>
                        <th>Prerequisite</th>
                        <th>Unit From</th>
                        <th>Unit To</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="courses.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="NUMBER" size="20"></th>
                            <th><input value="" name="PREVNUMBER" size="20"></th>
                            <th><input value="" name="DEPARTMENT" size="15"></th>
                            <th><input value="" name="GRADE" size="15"></th>
                            <th><input value="" name="LAB" size="15"></th>
                            <th><input value="" name="PREREQUISITE" size="15"></th>
                            <th><input value="" name="UNITFROM" size="15"></th>
                            <th><input value="" name="UNITTO" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="courses.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- get course number --%>
                            <td>
                                <input value="<%= rs.getString("NUMBER") %>" 
                                    name="NUMBER" size="20">
                            </td>
    
                            <%-- Get previous number --%>
                            <td>
                                <input value="<%= rs.getString("PREVNUMBER") %>" 
                                    name="PREVNUMBER" size="20">
                            </td>
    
                            <%-- Get the department --%>
                            <td>
                                <input value="<%= rs.getString("DEPARTMENT") %>"
                                    name="DEPARTMENT" size="15">
                            </td>
    
                            <%-- Get the grade option --%>
                            <td>
                                <input value="<%= rs.getString("GRADE") %>" 
                                    name="GRADE" size="15">
                            </td>

                            <%-- Get the lab requirement --%>
                            <td>
                                <input value="<%= rs.getString("LAB") %>" 
                                    name="LAB" size="15">
                            </td>

                            <%-- get prerequisite  --%>
                            <td>
                                <input value="<%= rs.getString("PREREQUISITE") %>" 
                                    name="PREREQUISITE" size="15">
                            </td>

                            <%-- get units range from  --%>
                            <td>
                                <input value="<%= rs.getInt("UNITFROM") %>" 
                                    name="UNITFROM" size="15">
                            </td>

                            <%-- get units range to  --%>
                            <td>
                                <input value="<%= rs.getInt("UNITTO") %>" 
                                    name="UNITO" size="15">
                            </td>

                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="courses.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getString("NUMBER") %>" name="NUMBER">
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