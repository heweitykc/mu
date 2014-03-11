<%@ Page Language="C#" %>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en"> 
    <head>
        <title></title>
        <style type="text/css" media="screen"> 
            html, body  { height:100%; }
            body { margin:0; padding:0; overflow:auto; text-align:center; 
                   background-color: #000000; }   
            object:focus { outline:none; }
        </style>
    </head>
    <body>
<%
	String paramstr = "uid=" + Request["uid"] + "&r=" + DateTime.Now.Ticks.ToString();
%>
		<object width="100%" height="100%">
		  <param name="movie" value="RenderScene.swf?<%=paramstr%>">
		  <param name="quality" value="high">
		  <param name="bgcolor" value="#000000">
		  <param name="wmode" value="direct">
		  <embed src="RenderScene.swf?<%=paramstr%>" wmode="direct" width="100%" height="100%" quality="high"  type="application/x-shockwave-flash" bgcolor="#000000"></embed>
		</object>
	</body>
</html>
