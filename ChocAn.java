package com.orderdata.ws;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.PreparedStatement;


public class ChocAn {

  public static void main(String[] args) {
		try {

			 //Register the JDBC driver for MySQL.
			 Class.forName("com.mysql.jdbc.Driver");
			 
			 String user;
			 String pass;
			 String url;
			 String query;
			 
					
			//Parameters for DB connection	 
			 url = "jdbc:mysql://localhost:8889/chocAn";
			 user="root";
			 pass="root";
			 
			 //returns to result to Console
			 int userID = 3;
			 query="CALL GetStatus(" + userID + ")";
			 
			 //Takes (option, argument value)
			 //option 1 Service Rep (arg = 0)
			 //option 2 Provider Rep (arg = ProviderID)
			 //option 3 Member Rep (arg = MemberID)
			 int opt = 2;
			 int providerID = 1;
			 String query2 = "CALL GetReport(" + opt + "," + providerID + ")";
			 
			 //String Var for Date
			 String qDate = "2012-01-05";
			 
			 //Takes (argument value Date start to current date)
			 String query3 = "CALL GetManagerReport("+ qDate +")";

			 //Establish Connection to Database
			 Connection con = DriverManager.getConnection(url, user, pass);
			 
			 //Prepare Test Query 1
			 PreparedStatement statement = con.prepareStatement(query);
			 //Catch Result and Execute Query 1
			 ResultSet result = statement.executeQuery();
			 
			//For Query returning result
			 if (result.next())
			 {
				System.out.println(result.getString(1));				 
			 }
			 
			 //Prepare Test Query 2
			 PreparedStatement statement2 = con.prepareStatement(query2);
			 //Execute Query 2 - No returning result (writes to file)
			 statement2.executeQuery();
			 
			//Prepare Test Query 3
			 PreparedStatement statement3 = con.prepareStatement(query3);
			 //Execute Query 3 - No returning result (writes to file)
			 statement3.executeQuery();
			 
			 
			 
			 con.close();
		 }catch( Exception e ) {
			 e.printStackTrace();
		 }
		
	}

}
