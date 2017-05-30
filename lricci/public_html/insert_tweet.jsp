<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.mysql.jdbc.*" %>

<% 
	String tweet_text = request.getParameter("tweet"); //suck in html ; store in java var
	String user_id = request.getParameter("p_key");
	int status = 0;

	java.sql.Connection conn = null;
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        String url = "jdbc:mysql://localhost:3306/lricci";   //location and name of database
        String userid = "lricci";
        String loginpassword = "dalton123";
        conn = DriverManager.getConnection(url, userid, loginpassword);      //connect to database
        
    
    java.sql.Statement statement = conn.createStatement();
    
    if (tweet_text.length() > 0) {
    	
    	
    	String[] data = tweet_text.split(" ");
    	
    	
    	ArrayList<String> hashtags = new ArrayList<String>();
    	
    	for (int i = 0; i < data.length; i++) {
    		if (data[i].substring(0,1).equals("#")) {
    			hashtags.add(data[i].substring(1));
    		}
    	}
    	
    	java.sql.Statement stmt1 = conn.createStatement();
	
		String query_hashtagList = "";
    	
    	String hash_id = "";
    	ArrayList<String> newHashtags = new ArrayList<String>();
    	//insert new hashtags
    	for (int i = 0; i < hashtags.size(); i++) {
    		query_hashtagList = "select hashtag_id from lricci.hashtags where hashtag=" + "'" + hashtags.get(i) + "'" ;
    		
     		java.sql.ResultSet rs_hashtagList = stmt1.executeQuery(query_hashtagList);
    		
    		if (rs_hashtagList.next())  {
    		
    		} else {
    			java.sql.PreparedStatement insert_Hashtag = conn.prepareStatement("insert into lricci.hashtags (hashtag) values (?)");
    			insert_Hashtag.setString(1, hashtags.get(i));
    			status = insert_Hashtag.executeUpdate();
    		}
    		
    	}
    	
    	//insert tweet
		java.sql.PreparedStatement insert_Tweet = conn.prepareStatement("insert into lricci.tweets (user_id, tweet) values (?, ?);");
    
    	insert_Tweet.setString(1, user_id);
    	insert_Tweet.setString(2, tweet_text);
    	status = insert_Tweet.executeUpdate();
    	
    	
    	
    	//insert relationship
    	String query_tweetID = "select max(tweet_id) from lricci.tweets where user_id = " + user_id + ";";
    	
    	java.sql.ResultSet rs_tweetID = stmt1.executeQuery(query_tweetID);
    	
    	int insertedTweetID = 0;
    	int insertedHashtagID = 0;
    	
    	while (rs_tweetID.next()) {
    		insertedTweetID = rs_tweetID.getInt("max(tweet_id)");
    	}
    	
    	
    	for (int i = 0; i < hashtags.size(); i++) {
    		query_hashtagList = "select hashtag_id from lricci.hashtags where hashtag=" + "'" + hashtags.get(i) + "';" ;
     		java.sql.ResultSet rs_hashtagList = stmt1.executeQuery(query_hashtagList);
			if (rs_hashtagList.next()) {
    			insertedHashtagID = rs_hashtagList.getInt("hashtag_id");
    		}
    		
     		java.sql.PreparedStatement insert_TweetHashtagRel = conn.prepareStatement("insert into lricci.tweet_hashtag_rel (hashtag_id, tweet_id) values (?, ?)");
     		insert_TweetHashtagRel.setInt(1, insertedHashtagID);
     		insert_TweetHashtagRel.setInt(2, insertedTweetID);
     		
     		status = insert_TweetHashtagRel.executeUpdate();
    	}
    	
    	
    	
    	
    }
    
    
    
    response.sendRedirect("twitter-home.jsp?p_key=" + user_id);

	if(status > 0) {
		//response.sendRedirect("http://www.nytimes.com?key=4");
		//fail and go back to login page
	}
%>