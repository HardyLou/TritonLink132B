package test;

import java.sql.*;

/**
 * 
 * @author Hardy Lou
 * File tests whether this file is connected to the database.
 *
 */
public class Main {
    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
          System.out.println("——– PostgreSQL JDBC Connection Testing ————");
          try {
        	  Class.forName("org.postgresql.Driver");
        	  Connection connection = null;
        	  connection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/cse132b", "postgres", "hardylou");
             
        	  if (connection != null)
        	  {
        		  Statement stmt = null;
                  String query="select * from Student";
                  stmt = connection.createStatement();
                  ResultSet rs=stmt.executeQuery(query);
                  while(rs.next())
                  {
                      System.out.print(""+rs.getString(1));
                  }
        	  }
        	  else
        		  System.out.println("Connection Failed!");
          }
          catch(Exception e){
                  e.printStackTrace();
          }
    
    }
}