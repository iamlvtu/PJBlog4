<%
define(function(require, exports, module){
	var xml = function(selectExp, context){
		return new xml.init(selectExp, context);
	}
	
	var core_push = Array.prototype.push;
	
	xml.init = function(selectExp, context){
		if ( context === undefined ){
			context = selectExp;
			selectExp = "";
		}else if ( selectExp === undefined ){
			selectExp = "";
		}
		
		this.length = 0;
		this.constructor = xml;
		xml.makeArray(context, this);

		return selectExp === "" ? this : this.find(selectExp);
	}
	
	xml.type = function(object){
		return Object.prototype.toString.call(object).split(" ")[1].toLowerCase().replace("]", "");
	}
	
	xml.saveToArray = function(object){
		var length = object.length;
		
		if ( xml.type(length) === "number" && length > 0 ){
			var x = [];
			for ( var i = 0 ; i < object.length ; i++ ){
				x.push(object[i]);
			}
			
			return x;
		}else{
			return [object];
		}
	}
	
	xml.makeArray = function( arr, results ){
		var type,
			ret = results || [];

		if ( arr != null ) {
			// The window, strings (and functions) also have 'length'
			// Tweaked logic slightly to handle Blackberry 4.7 RegExp issues #6930
			type = xml.type( arr );

			if ( arr.length == null || type === "string" || type === "function" || type === "regexp" || type === "object" ) {
				
				if ( type === "object" ){
					var isJson = false;
					try{
						for ( var i in arr ){
							isJson = true;
						}
						if ( isJson == true ){
							xml.merge( ret, arr );
						}else{
							core_push.call( ret, arr );
						}
					}catch(e){core_push.call( ret, arr );}
				}else{
					core_push.call( ret, arr );
				}
			} else {
				xml.merge( ret, arr );
			}
		}

		return ret;
	}
	
	xml.merge = function( first, second ){
		var l = second.length,
			i = first.length,
			j = 0;

		if ( typeof l === "number" ) {
			for ( ; j < l; j++ ) {
				first[ i++ ] = second[ j ];
			}

		} else {
			while ( second[j] !== undefined ) {
				first[ i++ ] = second[ j++ ];
			}
		}

		first.length = i;

		return first;
	}
	
	xml.map = function( elems, callback, arg ) {
		var value, key,
			ret = [],
			i = 0,
			length = elems.length,
			// jquery objects are treated as arrays
			isArray = elems instanceof xml || length !== undefined && typeof length === "number" && ( ( length > 0 && elems[ 0 ] && elems[ length -1 ] ) || length === 0 || (xml.type(elems) === "array") ) ;

		// Go through the array, translating each of the items to their
		if ( isArray ) {
			for ( ; i < length; i++ ) {
				value = callback( elems[ i ], i, arg );

				if ( value != null ) {
					ret[ ret.length ] = value;
				}
			}

		// Go through every key on the object,
		} else {
			for ( key in elems ) {
				value = callback( elems[ key ], key, arg );

				if ( value != null ) {
					ret[ ret.length ] = value;
				}
			}
		}

		// Flatten any nested arrays
		return ret.concat.apply( [], ret );
	}
	
	xml.init.prototype = {
		each : function( callback, args ){
			var name,
				i = 0,
				obj = this,
				length = this.length,
				isObj = length === undefined || ( typeof obj === "function" );
				
	
			if ( args ) {
				if ( isObj ) {
					for ( name in this ) {
						if ( callback.apply( this[ name ], args ) === false ) {
							break;
						}
					}
				} else {
					for ( ; i < length; ) {
						if ( callback.apply( this[ i++ ], args ) === false ) {
							break;
						}
					}
				}
	
			// A special, fast, case for the most common use of each
			} else {
				if ( isObj ) {
					for ( name in this ) {
						if ( callback.call( this[ name ], name, this[ name ] ) === false ) {
							break;
						}
					}
				} else {
					for ( ; i < length; ) {
						if ( callback.call( this[ i ], i, this[ i++ ] ) === false ) {
							break;
						}
					}
				}
			}
	
			return this;
		},
		
		map : function( callback, arg ){
			return this.pushStack( xml.map(this, function( elem, i ) {
				return callback.call( elem, i, elem );
			}));
		},
		
		pushStack: function( elems, name, selector ) {
			var ret = xml.merge( this.constructor(), elems );
			ret.prevObject = this;
			ret.context = this.context;
	
			if ( name === "find" ) {
				ret.selector = this.selector + ( this.selector ? " " : "" ) + selector;
			} else if ( name ) {
				ret.selector = this.selector + "." + name + "(" + selector + ")";
			}

			return ret;
		},
		
		find : function(selectExp){
			return this.map(function(){

				if ( selectExp.length > 0 ){
					var selectExpSplitArray = selectExp.split(" "),
						d = [this], ret = [];
						
					for ( var i = 0 ; i < selectExpSplitArray.length ; i++ ){
						var e = [];
						for ( var j = 0 ; j < d.length ; j++ ){
							var elemetns = getExpElementsForArray(d[j], selectExpSplitArray[i]);
//							console.log("<ul>" + d[j].getAttribute("class") + "&gt;" + selectExpSplitArray[i] + "(" + elemetns.length +")");
//							if (elemetns.length > 0){
//							for ( var k = 0 ; k < elemetns.length ; k++ ){
//								console.log("<li>" + elemetns[k].getAttribute("class") + "</li>");
//							}}else{console.log("<li>none</li>")}
//							console.log("</ul>");
							e = e.concat(elemetns);
						}
						d = e;
					}

					return d;
				}else{
					return this;
				}
			});
		},
		
		slice : function(){
			return Array.prototype.slice.apply(this, arguments);
		},
		
		merge: function( first, second ) {
			var l = second.length,
				i = first.length,
				j = 0;
	
			if ( typeof l === "number" ) {
				for ( ; j < l; j++ ) {
					first[ i++ ] = second[ j ];
				}
	
			} else {
				while ( second[j] !== undefined ) {
					first[ i++ ] = second[ j++ ];
				}
			}
	
			first.length = i;
	
			return first;
		}
	}
	
	xml.createXml = function(){
		return new ActiveXObject(config.nameSpace.xml);
	}
	
	xml.save = function(path, object){
		object.save(selector.lock(path));
	}
	
	xml.load = function( loadXmlMessage, object ){
		var openStatus = false;
		if ( object === undefined ) object = xml.createXml();
		
		try{
			openStatus = object.loadXML( loadXmlMessage );
			if ( !openStatus ){
				try{
					openStatus = object.load(selector.lock( loadXmlMessage ));
				}catch(e){}
			}
		}catch(e){
			try{ openStatus = object.load(selector.lock( loadXmlMessage )); }catch(e){}
		}
		
		if ( openStatus !== false ){
			return object.documentElement;
		}else{
			return null;
		}
	}
	
	function getExpElementsForArray(element, exps){
		var exec = /([^\[]+)(\[([^\=]+)\=\'([^\']+)\'\])?/.exec(exps);
		
		if ( exec ){
			try{
				var c = element.getElementsByTagName(exec[1]),
					e = [];

				if ( exec[2] ){	
					for ( var j = 0 ; j < c.length ; j++ ){
						if ( c[j].getAttribute(exec[3]) === exec[4] ){
							e.push(c[j]);
						}
					}
				}else{
					if ( c.length === 0 ){
						e = [];
					}else{
						e = xml.saveToArray(c);
					}
				}
				
				return e;
			}catch(e){ return []; }
		}else{
			return [element];
		}
	}
	
	return xml;
});
%>