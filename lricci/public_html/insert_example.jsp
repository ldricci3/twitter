<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<%

	String first_name = request.getParameter("first"); //suck in html ; store in java var
	String last_name = request.getParameter("last");
	String email = request.getParameter("email");
	int status = 0;

	out.println("email is: " + email);

	
	String fullname = first_name + last_name;

	java.sql.Connection conn = null;
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        String url = "jdbc:mysql://127.0.0.1/gordie";   //location and name of database
        String userid = "gordie";
        String password = "happy95";
        conn = DriverManager.getConnection(url, userid, password);      //connect to database

	java.sql.PreparedStatement ps = conn.prepareStatement("insert into gordie.student_t (full_name) values (?)");

	ps.setString (1,fullname);
        status = ps.executeUpdate(); 

	if(status > 0)
		//response.sendRedirect("http://www.nytimes.com?key=4");
		//fail and go back to login page	
%>

<input type="hidden" name="key" value="99">
<h1> its a beautiful day in the neighborhood! </h1>



