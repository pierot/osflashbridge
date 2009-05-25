
//***********************************************************************************************************//	

function OSFlashBridgeDispatcher(eventType, data)
{
	$(document).trigger(eventType, data);
}	

function OSFlashBridgeListener(eventType, func)
{
	$(document).bind(eventType, function(e, data) { func(data); });
}

function OSFlashBridgeFlashDispatcher(func)
{
	if(oFlash && isFlashReady)
	{		
		if(arguments.length > 1)
			oFlash[func](Array.prototype.slice.call(arguments).slice(1)[0]);
		else
			oFlash[func]();
	}
}

//***********************************************************************************************************//	

if(!("console" in window) || !("firebug" in console)) 
{
    var names = ["log", "debug", "info", "warn", "error", "assert", "dir", "dirxml", "group", "groupEnd", "time", "timeEnd", "count", "trace", "profile", "profileEnd"];

    window.console = {};

    for(var i = 0; i < names.length; ++i) window.console[names[i]] = function() {};
}

function trace(msg)
{
	// alert(msg);
	
	if(console)	
		console.debug(msg);
}

function inspect(obj)
{
	if(console)	
		console.dir(obj);
}

//***********************************************************************************************************//	