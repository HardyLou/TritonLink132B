<%@page language="java" import="java.sql.*" %>
<% Class.forName("org.postgresql.Driver"); %>

<%@page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <title>Course Grade Distribution</title>
    </head>
    <body>
        <h1>Display information on the distribution of grades in particular courses and by particular professors</h1>
        
        <div style = "width:100%">
        
        <div style = "float:left; width:20%;">
            <%-- -------- Include menu HTML code -------- --%>
            <jsp:include page="menu.html" />                
        </div>
        
        <div style = "float:left; width: 80%;">
        <%!
        public class GradeReport {
            String URL = "jdbc:postgresql://localhost:5432/cse132b";
            String USERNAME = "postgres";
            String PASSWORD = "hardylou";

            Connection connection = null;
            PreparedStatement pstmt_ii = null;
            PreparedStatement pstmt_iii = null;
            PreparedStatement pstmt_iv = null;
            PreparedStatement pstmt_v = null;
            ResultSet rs_ii = null;
            ResultSet rs_iii = null;
            ResultSet rs_iv = null;
            ResultSet rs_v = null;

            public GradeReport(){
                
                try {
                    connection = DriverManager.getConnection(URL, USERNAME,PASSWORD);
                    
                    pstmt_ii = connection.prepareStatement(
                        "SELECT countA, countB, countC, countD, countOther"
                        + " FROM CPQG"
                        + " WHERE title = ? AND instructor = ? AND term = ?");
                    
                    pstmt_iii = connection.prepareStatement(
                       "SELECT countA, countB, countC, countD, countOther"
                        + " FROM CPG"
                        + " WHERE title = ? AND instructor = ?");
                    		
                    pstmt_iv = connection.prepareStatement(
                        "SELECT COUNT(CASE WHEN c.gradereceived IN ('A+','A','A-') THEN 1 END) AS numA,"
                              + "COUNT(CASE WHEN c.gradereceived IN ('B+','B','B-') THEN 1 END) AS numB,"
                              + "COUNT(CASE WHEN c.gradereceived IN ('C+','C','C-') THEN 1 END) AS numC,"
                              + "COUNT(CASE WHEN c.gradereceived IN ('D+','D','D-') THEN 1 END) AS numD,"
                              + "COUNT(CASE WHEN c.gradereceived IN ('F+','F','F-','P','NP') THEN 1 END) AS numOther"
                        + " FROM course a, class b, classenrollment c"
                        + " WHERE a.title = ?"
                        + " AND a.title = b.coursetitle"
                        + " AND b.sectionid = c.sectionid");
                    
                    pstmt_v = connection.prepareStatement(
                    	"SELECT AVG(t.value)"
                    	+ " FROM course a, class b, classenrollment c, gradeconversion t"
                        + " WHERE a.title = ? AND b.instructor = ?"
                        + " AND a.title = b.coursetitle"
                        + " AND b.sectionid = c.sectionid"
                        + " AND c.gradereceived = t.lettergrade");
                    
                } catch (SQLException e){
                    e.printStackTrace();
                }

            }

            public ResultSet getDistribution(String TITLE, String INSTRUCTOR, String TERM){
                try{
                    pstmt_ii.setString(1, TITLE);
                    pstmt_ii.setString(2, INSTRUCTOR);
                    pstmt_ii.setString(3, TERM);

                    rs_ii = pstmt_ii.executeQuery();
                } catch (SQLException e){
                    e.printStackTrace();
                }

                return rs_ii;
            }
            
            public ResultSet getDistribution(String TITLE, String INSTRUCTOR){
                try{
                    pstmt_iii.setString(1, TITLE);
                    pstmt_iii.setString(2, INSTRUCTOR);

                    rs_iii = pstmt_iii.executeQuery();
                } catch (SQLException e){
                    e.printStackTrace();
                }

                return rs_iii;
            }

            public ResultSet getDistribution(String TITLE){
                try{
                    pstmt_iv.setString(1, TITLE);

                    rs_iv = pstmt_iv.executeQuery();
                } catch (SQLException e){
                    e.printStackTrace();
                }

                return rs_iv;
            }
            
            public ResultSet getGPA(String TITLE, String INSTRUCTOR){
                try{
                    pstmt_v.setString(1, TITLE);
                    pstmt_v.setString(2, INSTRUCTOR);

                    rs_v = pstmt_v.executeQuery();
                } catch (SQLException e){
                    e.printStackTrace();
                }

                return rs_v;
            }
        }
        %>
        
        <%
            String courseTitle = new String();
            String classInstructor = new String();
            String classTerm = new String();

            //if (request.getParameter("TITLE") != null) {
                courseTitle = request.getParameter("TITLE");
            //}
            
            //if (request.getParameter("INSTRUCTOR") != null) {
                classInstructor = request.getParameter("INSTRUCTOR");
            //}
            
            //if (request.getParameter("TERM") != null) {
                classTerm = request.getParameter("TERM");
            //}

            GradeReport stdreport = new GradeReport();
            ResultSet part_ii = stdreport.getDistribution(courseTitle, classInstructor, classTerm);
            ResultSet part_iii = stdreport.getDistribution(courseTitle, classInstructor);
            ResultSet part_iv = stdreport.getDistribution(courseTitle);
            ResultSet part_v = stdreport.getGPA(courseTitle, classInstructor);
        %>
        <table border="1">
            <tbody>
                Count of grades given by Professor Y at Quarter Z to the students taking Course X
                <tr>
                    <td>A</td>
                    <td>B</td>
                    <td>C</td>
                    <td>D</td>
                    <td>Other</td>
                </tr>
                <% while (part_ii.next()){ %>
                <tr>
                    <td><%= part_ii.getDouble("countA") %></td>
                    <td><%= part_ii.getDouble("countB") %></td>
                    <td><%= part_ii.getDouble("countC") %></td>
                    <td><%= part_ii.getDouble("countD") %></td>
                    <td><%= part_ii.getDouble("countOther") %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        
        <table border="1">
            <tbody>
                Count of grades given by Professor Y to students in Course X over the years
                <tr>
                    <td>A</td>
                    <td>B</td>
                    <td>C</td>
                    <td>D</td>
                    <td>Other</td>
                </tr>
                <% while (part_iii.next()){ %>
                <tr>
                    <td><%= part_iii.getDouble("countA") %></td>
                    <td><%= part_iii.getDouble("countB") %></td>
                    <td><%= part_iii.getDouble("countC") %></td>
                    <td><%= part_iii.getDouble("countD") %></td>
                    <td><%= part_iii.getDouble("countOther") %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        
        <table border="1">
            <tbody>
                Count of grades given to students in Course X over the years
                <tr>
                    <td>A</td>
                    <td>B</td>
                    <td>C</td>
                    <td>D</td>
                    <td>Other</td>
                </tr>
                <% while (part_iv.next()){ %>
                <tr>
                    <td><%= part_iv.getInt("numA") %></td>
                    <td><%= part_iv.getInt("numB") %></td>
                    <td><%= part_iv.getInt("numC") %></td>
                    <td><%= part_iv.getInt("numD") %></td>
                    <td><%= part_iv.getInt("numOther") %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        
        <table border="1">
            <tbody>
                GPA of grades that Professor Y has give in Course X over the years
                <tr>
                    <td>GPA</td>
                </tr>
                <% while (part_v.next()){ %>
                <tr>
                    <td><%= part_v.getDouble(1) %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        
        </div>
        </div>
    </body>
</html>