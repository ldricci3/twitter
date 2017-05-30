<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<%

	String first_name = request.getParameter("first_name"); //suck in html ; store in java var
	String last_name = request.getParameter("last_name");
	String email = request.getParameter("email");
	String username = request.getParameter("username");
	String password = request.getParameter("password");
	int status = 0;

	out.println("email is: " + email);

	
	String fullname = first_name + last_name;

	java.sql.Connection conn = null;
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        String url = "jdbc:mysql://localhost:3306/lricci";   //location and name of database
        String userid = "lricci";
        String loginpassword = "dalton123";
        conn = DriverManager.getConnection(url, userid, loginpassword);      //connect to database
        
    
    java.sql.Statement statement = conn.createStatement();
    
    String query1 = "select user_id from lricci.users where username = '" + username + "';";
    
    java.sql.Statement stmt = conn.createStatement();

    
    java.sql.ResultSet rs = stmt.executeQuery(query1);
    
    // while(rs.next()) {
// 		String p_key = rs.getString("user_id");
// 	}
    
    if (rs.next()) {
    	// java.sql.PreparedStatement insertUser = conn.prepareStatement("insert into lricci.users (username, password, first_name, last_name, email) values (" + username + ", " + password + ", " + first_name + ", " + last_name + ", " + email + ");");
    	
    } else {
    	// response.Redirect("sign_up.jsp?error=The username already exists");
    	java.sql.PreparedStatement insertUser = conn.prepareStatement("insert into lricci.users (username, password, first_name, last_name, email) values (?, ?, ?, ?, ?)");
    	
    	insertUser.setString(1, username);
    	insertUser.setString(2, password);
    	insertUser.setString(3, first_name);
    	insertUser.setString(4, last_name);
    	insertUser.setString(5, email);
    	
    	status = insertUser.executeUpdate();
    	
    	String query2 = "select user_id from lricci.users where username = '" + username + "';";
    	
    	java.sql.ResultSet rs2 = stmt.executeQuery(query2);
    	
    	int p_key = 0;
		while (rs2.next()) {
			p_key = rs2.getInt("user_id");
		}
    	
    	java.sql.PreparedStatement followSelf = conn.prepareStatement("insert into lricci.follow_rel (follower_id, followee_id) values (?, ?)");
    	
    	followSelf.setInt(1, p_key);
    	followSelf.setInt(2, p_key);
    	
    	status = followSelf.executeUpdate();
    	
    	response.sendRedirect("twitter-home.jsp?p_key=" + p_key);
    }
    // java.sql.PreparedStatement ps = conn.prepareStatement("insert into gordie.student_t (full_name) values (?)");

	// ps.setString (1,fullname); 

	if(status > 0)
		//response.sendRedirect("http://www.nytimes.com?key=4");
		//fail and go back to login page	
%>

<input type="hidden" name="key" value="99">
<h1> its a beautiful day in the neighborhood! <%=status%> </h1>

<h1> 

