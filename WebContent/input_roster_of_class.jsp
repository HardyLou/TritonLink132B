<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <title>Roster of Class</title>
    </head>
    <body>

        <h1>Display the roster of a class</h1>
        
        <div style = "width:100%">
        
            <div style = "float:left; width:20%;">
                <%-- -------- Include menu HTML code -------- --%>
                <jsp:include page="menu.html" />                
            </div>
        
            <div style = "float:left; width:80%;">
                <form name="form_roster_of_class" action="display_roster_of_class.jsp" method="POST">
                        <table border="1">
                        <tbody>
                            <tr>   
                                <td>Class Title :</td>
                                <td><input value="" name="TITLE" size="20"></td>
                            </tr>
                        </tbody>
                    </table>
                    <input type="reset" value="Clear" name="clear" />
                    <input type="submit" value="Submit" name="submit" />
                </form>
            </div>
        
        </div>
        
    </body>
</html>
