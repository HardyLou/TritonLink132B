<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Course Types</title>
</head>

<body>


    <table border="1">
        <tr>
            <td valign="top">
                <%-- -------- Include menu HTML code -------- --%>
                <jsp:include page="menu_courses.html" />
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
                            "INSERT INTO CourseType VALUES (?, ?)");
 
                        pstmt.setString(1, request.getParameter("COURSETITLE"));
                        pstmt.setString(2, request.getParameter("TYPE"));

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
                            "UPDATE CourseType SET TYPE = ? WHERE COURSETITLE = ?");

                        pstmt.setString(1, request.getParameter("TYPE"));
                        pstmt.setString(2, request.getParameter("COURSETITLE"));

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
                            "DELETE FROM CourseType WHERE COURSETITLE = ? AND TYPE = ?");

                        pstmt.setString(1, request.getParameter("COURSETITLE"));
                        pstmt.setString(2, request.getParameter("TYPE"));
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
                        ("SELECT * FROM CourseType");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Course</th>
                        <th>Type</th>
                    </tr>
                    <tr>
                        <form action="course_types.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="COURSETITLE" size="20"></th>
                            <th><input value="" name="TYPE" size="20"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="course_types.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the SSN, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("COURSETITLE") %>" 
                                    name="COURSETITLE" size="20">
                            </td>

                            <%-- Get the SSN, which is a number --%>
                            <td>
                                <input value="<%= rs.getString("TYPE") %>" 
                                    name="TYPE" size="20">
                            </td>
    
                        </form>
                        <form action="course_types.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getString("COURSETITLE") %>" name="COURSETITLE">
                            <input type="hidden" 
                                value="<%= rs.getString("TYPE") %>" name="TYPE">
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