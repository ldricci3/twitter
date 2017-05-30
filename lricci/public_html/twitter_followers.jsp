<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>
<%
	String p_key = request.getParameter("p_key");
	
	java.sql.Connection conn = null;
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        String url = "jdbc:mysql://localhost:3306/lricci";   //location and name of database
        String userid = "lricci";
        String loginPassword = "dalton123";
        conn = DriverManager.getConnection(url, userid, loginPassword);      //connect to database
        
    java.sql.Statement stmt = conn.createStatement();
	
	String query_userInfo = "select * from lricci.users where user_id = '" + p_key + "';";
	
	java.sql.ResultSet rs_userInfo = stmt.executeQuery(query_userInfo);
	
	String username = "";
	String first_name = "";
	String last_name = "";
	String email = "";
	
	while (rs_userInfo.next()) {
		username = rs_userInfo.getString("username");
		first_name = rs_userInfo.getString("first_name");
		last_name = rs_userInfo.getString("last_name");
		email = rs_userInfo.getString("email");
	}
	
	String query_tweetCount = "select count(*) from tweets where user_id = '" + p_key + "';";
	
	java.sql.ResultSet rs_tweetCount = stmt.executeQuery(query_tweetCount);
	
	int tweetCount = 0;
	while (rs_tweetCount.next()) {
		tweetCount = rs_tweetCount.getInt("count(*)");
	}
	
	String query_followerCount = "select count(*) from follow_rel where follower_id = '" + p_key + "';";
	
	java.sql.ResultSet rs_followerCount = stmt.executeQuery(query_followerCount);
	
	int followerCount = 0;
	while (rs_followerCount.next()) {
		followerCount = rs_followerCount.getInt("count(*)") - 1;
	}
	
	String query_followeeCount = "select count(*) from follow_rel where followee_id = '" + p_key + "';";
	
	java.sql.ResultSet rs_followeeCount = stmt.executeQuery(query_followeeCount);
	
	int followeeCount = 0;
	while (rs_followeeCount.next()) {
		followeeCount = rs_followeeCount.getInt("count(*)") - 1;
	}
 	
 	
%>
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title></title>
    <meta name="description" content="">
    <meta name="author" content="">
    <style type="text/css">
    	body {
    		padding-top: 60px;
    		padding-bottom: 40px;
    	}
    	.sidebar-nav {
    		padding: 9px 0;
    	}
    </style>    
    <link rel="stylesheet" href="css/gordy_bootstrap.min.css">
</head>
<body class="user-style-theme1">
	<div class="navbar navbar-inverse navbar-fixed-top">
		<div class="navbar-inner">
			<div class="container">
                <i class="nav-home"></i> <a href="#" class="brand">!Twitter</a>
				<div class="nav-collapse collapse">
					<p class="navbar-text pull-right">Logged in as <a href="#" class="navbar-link"><%=username%></a>
					</p>
					<ul class="nav">
						<li class="active"><a href="index.html">Home</a></li>
						<li><a href="queries.html">Test Queries</a></li>
						<li><a href="twitter-signin.html">Main sign-in</a></li>
					</ul>
				</div><!--/ .nav-collapse -->
			</div>
		</div>
	</div>

    <div class="container wrap">
        <div class="row">

            <!-- left column -->
            <div class="span4" id="secondary">
                <div class="module mini-profile">
                    <div class="content">
                        <div class="account-group">
                            <a href=twitter-home.jsp?p_key=<%=p_key%>>
                                <img class="avatar size32" src="images/pirate_normal.jpg" alt="Gordy">
                                <b class="fullname"><%=first_name%> <%=last_name%></b>
                                <small class="metadata">View my profile page</small>
                            </a>
                        </div>
                    </div>
                    <div class="js-mini-profile-stats-container">
                        <ul class="stats">
                            <li><a href=twitter-home.jsp?p_key=<%=p_key%>><strong><%=tweetCount%></strong>Tweets</a></li>
                            <li><a href=twitter_following.jsp?p_key=<%=p_key%>><strong><%=followerCount%></strong>Following</a></li>
                            <li><a href=twitter_followers.jsp?p_key=<%=p_key%>><strong><%=followeeCount%></strong>Followers</a></li>
                        </ul>
                    </div>
                </div>

                <div class="module other-side-content">
                    <div class="content"
                        <p>Some other content here</p>
                    </div>
                </div>
            </div>

            <!-- right column -->
            <div class="span8 content-main">
                <div class="module">
                    <div class="content-header">
                        <div class="header-inner">
                            <h2 class="js-timeline-title">Followers</h2>
                        </div>
                    </div>

                    <!-- new tweets alert -->
                    <div class="stream-item hidden">
                        <div class="new-tweets-bar js-new-tweets-bar well">
                            2 new Tweets
                        </div>
                    </div>

                    <!-- all tweets -->
                    <div class="stream home-stream">
                    	<%
                    			
                    		String query_followers = "select * from users inner join follow_rel on users.user_id = follow_rel.follower_id where followee_id ='" + p_key + "';";
                    		
                    		
                    		java.sql.Statement stmt2 = conn.createStatement();
                    		
                    		java.sql.ResultSet rs_followers = stmt2.executeQuery(query_followers);
                    		
                    		int follower_id = 0;
                    		String follower_username = "";
                    		String follower_first_name = "";
                    		String follower_last_name = "";
                    		String follower_fullname = "";
                    		
                    		while(rs_followers.next()) {
                    			follower_id = rs_followers.getInt("user_id");
                    			
                    			if (!Integer.toString(follower_id).equals(p_key)) {
                    				follower_username = rs_followers.getString("username");
                    				follower_first_name = rs_followers.getString("first_name");
                    				follower_last_name = rs_followers.getString("last_name");
                    			
                    				follower_fullname = follower_first_name + " " + follower_last_name;
                    	%>

                        <!-- start tweet -->
                        <div class="js-stream-item stream-item expanding-string-item">
                            <div class="tweet original-tweet">
                                <div class="content">
                                    <div class="stream-item-header">
                                        <a class="account-group">
                                            <img class="avatar" src="images/obama.png" alt="Barak Obama">
                                            <strong class="fullname"><%=follower_fullname%></strong>
                                            <span>&rlm;</span>
                                            <span class="username">
                                                <s>@</s>
                                                <b><%=follower_username%></b>
                                            </span>
                                        </a>
                                    </div>
                                </div>
                            </a>
                                <div class="expanded-content js-tweet-details-dropdown"></div>
                            </div>
                        </div><!-- end tweet -->
                        <%
                        		}
                        	}
                        %>

                    </div>
                    <div class="stream-footer"></div>
                    <div class="hidden-replies-container"></div>
                    <div class="stream-autoplay-marker"></div>
                </div>
                </div>
               
            </div>
        </div>
    </div>
     <!-- Le javascript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
     <script type="text/javascript" src="js/main-ck.js"></script>
  </body>
</html>