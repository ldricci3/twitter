<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>
<%
	String p_key = request.getParameter("p_key");
	String h_key = request.getParameter("h_key");
	
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
	
	String query_hashtag = "select * from hashtags where hashtag_id = '" + h_key + "';";
	
	java.sql.ResultSet rs_hashtag = stmt.executeQuery(query_hashtag);
	
	String hashtag = "";
	while (rs_hashtag.next()) {
		hashtag = rs_hashtag.getString("hashtag");
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
                    <form action="insert_tweet.jsp" method="get">
                        <textarea name="tweet" class="tweet-box" placeholder="Compose new Tweet..." id="tweet-box-mini-home-profile"></textarea>
                    	
                    	<input type="Submit" value="Tweet It!">
                    	
                    	
                		<input type="hidden" name="p_key" value="<%=p_key%>">
                		
                		
                    </form>
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
                            <h2 class="js-timeline-title">#<%=hashtag%></h2>
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
                    			
                    		String query_combinedTweets = "select * from tweets inner join tweet_hashtag_rel on tweets.tweet_id=tweet_hashtag_rel.tweet_id where tweet_hashtag_rel.hashtag_id = " + h_key + " order by tweets.tweet_id asc;";
                    		
                    		java.sql.Statement stmt1 = conn.createStatement();
                    		java.sql.Statement stmt2 = conn.createStatement();
                    		java.sql.ResultSet rs_combinedTweets = stmt1.executeQuery(query_combinedTweets);
                    		
                    		String tweet = "";
                    		int tweet_tweet_id = 0;
                    		int tweet_user_id = 0;
                    		String tweet_username = "";
                    		String tweet_first_name = "";
                    		String tweet_last_name = "";
                    		String tweet_fullname = "";
                    		String tweet_final = "";
                    		int hashtag_id = 0;
                    		
                    		while(rs_combinedTweets.next()) {
                    			hashtag_id = 0;
                    			tweet_final = "";
                    			tweet_tweet_id = rs_combinedTweets.getInt("tweet_id");
                    			tweet_user_id = rs_combinedTweets.getInt("user_id");
                    			tweet = rs_combinedTweets.getString("tweet");
                    			
                    			String query_tweetUser = "select * from lricci.users where user_id = " + tweet_user_id + ";";
                    			
                    			java.sql.ResultSet rs_tweetUser = stmt2.executeQuery(query_tweetUser);
                    			while (rs_tweetUser.next()) {
                    				tweet_username = rs_tweetUser.getString("username");
                    				tweet_first_name = rs_tweetUser.getString("first_name");
                    				tweet_last_name = rs_tweetUser.getString("last_name");
                    			}
                    			tweet_fullname = tweet_first_name + " " + tweet_last_name;
                    			
                    			String[] data = tweet.split(" ");
                    			
                    			for (int i = 0; i < data.length; i++) {
                    				if (data[i].substring(0,1).equals("#")) {
                    					String query_hashtagID = "select * from lricci.hashtags where hashtag = '" + data[i].substring(1) + "';";
                    					
                    					java.sql.ResultSet rs_hashtagID = stmt2.executeQuery(query_hashtagID);
                    					
                    					while (rs_hashtagID.next()) {
                    						hashtag_id = rs_hashtagID.getInt("hashtag_id");
                    					}
                    					
                    					tweet_final = tweet_final + " <a href='twitter-hashtag.jsp?p_key=" + p_key + "&h_key=" + hashtag_id + "'>" + data[i] + "</a>";
                    				} else {
                    					tweet_final = tweet_final + " " + data[i];
                    				}
                    			}
                    	%>

                        <!-- start tweet -->
                        <div class="js-stream-item stream-item expanding-string-item">
                            <div class="tweet original-tweet">
                                <div class="content">
                                    <div class="stream-item-header">
                                        <small class="time">
                                            <a href="#" class="tweet-timestamp" title="10:15am - 16 Nov 12">
                                                <span class="_timestamp">6m</span>
                                            </a>
                                        </small>
                                        <a class="account-group">
                                            <img class="avatar" src="images/obama.png" alt="Barak Obama">
                                            <strong class="fullname"><%=tweet_fullname%></strong>
                                            <span>&rlm;</span>
                                            <span class="username">
                                                <s>@</s>
                                                <b><%=tweet_username%></b>
                                            </span>
                                        </a>
                                    </div>
                                    <p class="js-tweet-text">
                                        <%=tweet_final%>
                                    </p>
                                </div>
                            </a>
                                <div class="expanded-content js-tweet-details-dropdown"></div>
                            </div>
                        </div><!-- end tweet -->
                        <%
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