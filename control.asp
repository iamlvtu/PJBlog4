<!--#include file="config.asp" --><%
	var page = http.get("p");
	Session("admin") = true;
	function checkStatusAndCustomPage(){
		if ( Session("admin") !== true ){
			return "login";
		}else if ( page.length === 0 ){
			return "index";
		}else{
			return page;
		}
	}
%><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="assets/css/control.css" media="all" />
<link rel="stylesheet" href="assets/css/page-<%=checkStatusAndCustomPage()%>.css" media="all" />
<script language="javascript" src="assets/js/core/sizzle.js"></script>
<title>PJBlog4 管理后台</title>
</head>
<body>
<div id="navtion" class="tpl-navtion fn-black-opacity">
	<div class="tpl-wrapper fn-clear">
    	<div class="logo"></div>
        <div class="nav-list">
        	<ul>
            	<li><a href="">首页</a></li>
                <li><a href="">分类</a></li>
                <li><a href="">日志</a></li>
                <li><a href="">主题</a></li>
                <li><a href="">插件</a></li>
                <li><a href="">文档</a></li>
            </ul>
        </div>
        <div class="nav-user">
        	<span class="name">sevio</span>
            <a href="javascript:;" class="item">设置<ul><li>全局设置</li><li>修改密码</li></ul></a>
            <a href="javascript:;">官方</a>
            <a href="javascript:;">退出</a>
        </div>
    </div>   
</div>

<div id="content" class="tpl-wrapper">
	<%
		try{
			include("server/web/page-" + checkStatusAndCustomPage());
		}catch(e){
			console.log("未找到模板。")
		}
	%>
</div>

<div id="footer" class="tpl-wrapper">
	<div class="foot-zone fn-clear">
    	<div class="one">微博帮助　意见反馈　开放平台　微博招聘　新浪网导航　社区管理中心　微博社区<br />
的撒即可发货，的撒谎发客户阿萨德否决了安乐死叫饭了爱的叫饭了。</div>
        <div class="two fn-clear"><div class="fn-left">北京微梦创科网络技术有限公司 京网文[2011]0398-130号 京ICP证100780号</div><div class="fn-right">Copyright © 1996-2012 SINA</div></div>
    </div>
</div>
<script language="javascript">
require(['assets/js/config'], function(status){
	if ( status === true ){
		console.log("Getting Success.");
	}else{
		console.log("Getting Config File Error.");
	}
});
</script>
</body>
</html>
