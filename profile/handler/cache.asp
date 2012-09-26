<%
define(function(require, exports, module){
	exports["global"] = function(){
		return "Select title, qq_appid, qq_appkey, website, description, theme, style From blog_global Where id=1";
	}
	
	exports["category"] = function(){
		return "Select id, cate_name, cate_info, cate_root, cate_count, cate_icon, cate_outlink, cate_outlinktext From blog_category Where cate_show=False Order By cate_order ASC";
	}
	
	exports["article_pages"] = function(){
		return "Select id From blog_article Order By log_updatetime DESC";
	}
	
	exports["article"] = function( id ){
		return "Select log_title, log_category, log_content, log_tags, log_views, log_posttime, log_updatetime From blog_article Where id=" + id;
	}
});
%>