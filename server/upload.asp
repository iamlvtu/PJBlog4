<!--#include file="../config.asp" -->
<%
require(["UPLOAD", "DATE", "FSO", "cache"], function(upload, _date, fso, cache){
	if ( Session("admin") === true ){
		try{
			var dbo = require("DBO"),
				connecte = require("openDataBase"),
				isImmediate = String(Request.QueryString("immediate")) === "1";
				
			if ( connecte === true ){
				var extArray = [];
				dbo.trave({
					conn: config.conn,
					sql: "Select * From blog_global Where id=1",
					callback: function(rs){
						extArray.push(
							rs("uploadimagetype").value, 
							rs("uploadswftype").value, 
							rs("uploadmediatype").value, 
							rs("uploadlinktype").value
						);
					}
				});
				
				extArray = extArray.join(",");
			
				var fileDate = _date.format(new Date(), "ymd"),
					folder = "profile/uploads/" + fileDate;
				
				if ( !fso.exsit(folder) ){
					fso.create(folder);
				}

				var route = upload({
					saveTo : folder,
					allowExt : extArray.split(",")
				});

				if ( route.Filedata !== undefined ){

					route = {
						success: true,
						data: {
							src: route.Filedata.savePath,
							file: route.Filedata.filename,
							ext: route.Filedata.fileExt,
							size: route.Filedata.fileSize
						}
					}

				}
				
				if ( route.success === true ){
					var uploadRetID = 0,
						rets;
				
					dbo.add({
						conn: config.conn,
						table: "blog_attachments",
						data: {
							attachext: route.data.ext,
							attachsize: route.data.size,
							attachpath: fileDate + "/" + route.data.file,
							attachviewcount: 0,
							attachuploadtime: _date.format(new Date(), "y/m/d h:i:s"),
							attachfilename: route.data.file
						},
						callback: function(){
							uploadRetID = this("id").value;
						}
					});
					
					if ( uploadRetID > 0 ){
						cache.build("attachments");
					
						rets = {
							err: "",
							msg: "server/binary.asp?id=" + uploadRetID
						}
						
						if ( isImmediate ){
							rets.msg = "!" + rets.msg;
						}
						
					}else{
						fso.destory(route.src);
						rets = {
							err: "上传失败",
							msg: "server error"
						}
					}
					
					console.log(JSON.stringify(rets));
					
				}else{
					console.log(JSON.stringify({
						err: route.error,
						msg: "server error"
					}));
				}
			}else{
				console.log(JSON.stringify({
					err: "打开数据库失败",
					msg: "server error"
				}));
			}
		}catch(e){
			console.log(JSON.stringify({
				err: e.message,
				msg: "server error"
			}));
		}
	}else{
		console.log(JSON.stringify({
			err: "没有上传权限",
			msg: "server error"
		}));
	}
});
CloseConnect();
%>