<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<%

	String username = request.getParameter("handle"); //suck in html ; store in java var
	String password = request.getParameter("password");
	int status = 0;

	java.sql.Connection conn = null;
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        String url = "jdbc:mysql://localhost:3306/lricci";   //location and name of database
        String userid = "lricci";
        String loginPassword = "dalton123";
        conn = DriverManager.getConnection(url, userid, loginPassword);      //connect to database

	// java.sql.PreparedStatement ps = conn.prepareStatement("insert into gordie.student_t (full_name) values (?)");
	
	java.sql.Statement stmt = conn.createStatement();
	
	String query = "select * from lricci.users where username = '" + username + "' and password = '" + password + "';";
	
	java.sql.ResultSet rs = stmt.executeQuery(query);
	
	
	int p_key = 0;
	while (rs.next()) {
		p_key = rs.getInt("user_id");
	}
	
	if (p_key == 0) {
		
	} else {
		// response.sendRedirect("twitter-home.jsp?p_key=" + p_key);
		session.setVariable("p_key", Integer.toString(p_key));
		response.sendRedirect("twitter-home.jsp");
		
	}
	
	java.sql.PreparedStatement signin = conn.prepareStatement("select * from lricci.users where username = '" + username + "' and password = '" + password + "';");

	// ps.setString (1,fullname);
    
    
    

	if(status > 0)
		//response.sendRedirect("http://www.nytimes.com?key=4");
		//fail and go back to login page	
%>

<input type="hidden" name="key" value="99">
<h1> its a beautiful day in the neighborhood!</h1>



