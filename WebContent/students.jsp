<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
<title>Students</title>
</head>

<body>
    <table border="1">
        <tr>
            <td valign="top">
                <%-- -------- Include menu HTML code -------- --%>
                <jsp:include page="menu_students.html" />
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
                            "INSERT INTO Student VALUES (?, ?, ?, ?, ?, ?, ?)");
 
                        pstmt.setInt(
                            1, Integer.parseInt(request.getParameter("SSN")));
                        pstmt.setString(2, request.getParameter("ID"));
                        pstmt.setString(3, request.getParameter("FIRSTNAME"));
                        pstmt.setString(4, request.getParameter("MIDDLENAME"));
                        pstmt.setString(5, request.getParameter("LASTNAME"));   
                        pstmt.setString(6, request.getParameter("RESIDENCY"));
                        pstmt.setString(7, request.getParameter("ENROLLMENT"));
                        
/*
                        //conn.setAutoCommit(false);
                        //String asdf = request.getParameter("ID");
                        if (request.getParameter("RESIDENCY") == "California resident") {
                            PreparedStatement pstmt_2 = conn.prepareStatement(
                                    "INSERT INTO Course VALUES (?)");
                            pstmt_2.setString(1, "IT WORKED OMG");
                            int rowCount2 = pstmt_2.executeUpdate();
                        }
                        else {
                            PreparedStatement pstmt_2 = conn.prepareStatement(
                                    "INSERT INTO Course VALUES (?)");
                            pstmt_2.setString(1, "fuck");
                            int rowCount2 = pstmt_2.executeUpdate();
                        }
*/
                        
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
                            "UPDATE Student SET ID = ?, FIRSTNAME = ?, " +
                            "MIDDLENAME = ?, LASTNAME = ?, RESIDENCY = ?, ENROLLMENT = ? WHERE SSN = ?");
                        pstmt.setString(1, request.getParameter("ID"));
                        pstmt.setString(2, request.getParameter("FIRSTNAME"));
                        pstmt.setString(3, request.getParameter("MIDDLENAME"));
                        pstmt.setString(4, request.getParameter("LASTNAME"));
                        pstmt.setString(5, request.getParameter("RESIDENCY"));
                        pstmt.setString(6, request.getParameter("ENROLLMENT"));
                        pstmt.setInt(
                            7, Integer.parseInt(request.getParameter("SSN")));
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
                            "DELETE FROM Student WHERE SSN = ?");
                        pstmt.setInt(
                            1, Integer.parseInt(request.getParameter("SSN")));
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
                        ("SELECT * FROM Student");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>SSN</th>
                        <th>ID</th>
                        <th>First</th>
                        <th>Middle</th>
                        <th>Last</th>
                        <th>Residency</th>
                        <th>Enrollment</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="students.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="SSN" size="10"></th>
                            <th><input value="" name="ID" size="10"></th>
                            <th><input value="" name="FIRSTNAME" size="15"></th>
                            <th><input value="" name="MIDDLENAME" size="15"></th>
                            <th><input value="" name="LASTNAME" size="15"></th>
                            <th><input value="" name="RESIDENCY" size="15"></th>
                            <th><input value="" name="ENROLLMENT" size="15"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="students.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the SSN, which is a number --%>
                            <td>
                                <input value="<%= rs.getInt("SSN") %>" 
                                    name="SSN" size="10">
                            </td>
    
                            <%-- Get the ID --%>
                            <td>
                                <input value="<%= rs.getString("ID") %>" 
                                    name="ID" size="10">
                            </td>
    
                            <%-- Get the FIRSTNAME --%>
                            <td>
                                <input value="<%= rs.getString("FIRSTNAME") %>"
                                    name="FIRSTNAME" size="15">
                            </td>
    
                            <%-- Get the MIDDLENAME --%>
                            <td>
                                <input value="<%= rs.getString("MIDDLENAME") %>" 
                                    name="MIDDLENAME" size="15">
                            </td>
    
                            <%-- Get the LASTNAME --%>
                            <td>
                                <input value="<%= rs.getString("LASTNAME") %>" 
                                    name="LASTNAME" size="15">
                            </td>

                            <%-- Get the residency of the student --%>
                            <td>
                                <input value="<%= rs.getString("RESIDENCY") %>" 
                                    name="RESIDENCY" size="15">
                            </td>

                            <%-- Get ENROLLMENT --%>
                            <td>
                                <input value="<%= rs.getString("ENROLLMENT") %>" 
                                    name="ENROLLMENT" size="15">
                            </td>
    
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="students.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getInt("SSN") %>" name="SSN">
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