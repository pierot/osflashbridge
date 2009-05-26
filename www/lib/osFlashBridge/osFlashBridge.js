var oOwner = null;
var oViewer = null;
var oFlash = null;
var isFlashReady = false;
var oEnv;
var oURL;
var oURLParams;
var sDomain = "";
var oUserProfileParams;

//***********************************************************************************************************//	

if(gadgets && gadgets.util)
	gadgets.util.registerOnLoadHandler(osInit);

function osInit() 
{
	oEnv = opensocial.getEnvironment();
	
	if(gadgets)
	{
		if(gadgets.util)
			oURL = gadgets.util.getUrlParameters();
	
		if(gadgets.views)
			oURLParams = gadgets.views.getParams();
	}
	
	OSFlashBridgeInit();
	
	// gadgets.window.adjustHeight();
	
	// opensocial.requestPermission(permissions, reason, opt_callback);
	// opensocial.Enum.Gender
}

//***********************************************************************************************************//	

function OSFlashBridgeInit()
{
	trace("OSFlashBridgeInit");
	
	// SETTINGS
	sDomain = oEnv.getDomain();
	
	oUserProfileParams = {};
	oUserProfileParams[opensocial.DataRequest.PeopleRequestFields.PROFILE_DETAILS] = [opensocial.Person.Field.GENDER, opensocial.Person.Field.ID, opensocial.Person.Field.NAME, opensocial.Person.Field.THUMBNAIL_URL, opensocial.Person.Field.PROFILE_URL];
	// oUserProfileParams[opensocial.DataRequest.PeopleRequestFields.PROFILE_DETAILS] = [opensocial.Person.Field.EMAILS];
	
	oUserProfileParams[opensocial.DataRequest.PeopleRequestFields.FIRST] = 0;
	oUserProfileParams[opensocial.DataRequest.PeopleRequestFields.MAX] = 200;
	
	// trace(oEnv.supportsField(opensocial.Environment.ObjectType.PERSON, opensocial.Person.Field.EMAILS)); // false
	// trace(oEnv.supportsField(opensocial.Environment.ObjectType.MESSAGE_TYPE, opensocial.Message.Field.EMAILS)); // false
}

function OSFlashBridgeFlashReady()
{
	trace("OSFlashBridgeFlashReady");
	
	oFlash = swfobject.getObjectById("flash_flash");
	isFlashReady = true;
	
	OSFlashBridgeFlashDispatcher("onInit");
}

function OSFlashBridgeCountry()
{
	trace("OSFlashBridgeCountry is " + gadgets.Prefs.getCountry());
}

function OSFlashBridgeLanguage()
{
	trace("OSFlashBridgeLanguage is " + gadgets.Prefs.getLang());
}

function OSFlashBridgeOwner()
{
	trace("OSFlashBridgeOwner");
	
	OSFlashBridgeGenericUserProfile(opensocial.IdSpec.PersonId.OWNER, function(oUser)
	{
		oOwner = oUser;
		
		OSFlashBridgeFlashDispatcher("onOwner", oUser);
	});
}

function OSFlashBridgeCurrentUser() 
{
	trace("OSFlashBridgeCurrentUser");
	
	OSFlashBridgeGenericUserProfile(opensocial.IdSpec.PersonId.VIEWER, function(oUser)
	{
		if(oUser)
		{
			oViewer = oUser;

			OSFlashBridgeFlashDispatcher("onCurrentUser", oViewer);
		}
		else
		{
			trace("OSFlashBridgeCurrentUser NOT LOGGED IN");
			
			OSFlashBridgeFlashDispatcher("onCurrentUserNotLoggedIn");
		}
	});
}

function OSFlashBridgeUserProfile(userid) 
{
	trace("OSFlashBridgeUserProfile");
	
	OSFlashBridgeGenericUserProfile(userid, function(oUser)
	{
		if(oUser)
			OSFlashBridgeFlashDispatcher("onUserProfile", oUser);
		else
			OSFlashBridgeFlashDispatcher("onUserProfileError");
	});
}

function OSFlashBridgeGenericUserProfile(userid, callback) 
{
	trace("OSFlashBridgeGenericUserProfile");
	
	var oReq = opensocial.newDataRequest();
	
	oReq.add(oReq.newFetchPersonRequest(userid, oUserProfileParams), "user");
	oReq.send(function(oResp)
	{
		var oUser = oResp.get("user").getData(); 
		
		inspect(oUser);

		callback(oUser);
	});
}

function OSFlashBridgeOwnerFriends()
{
	trace("OSFlashBridgeFriends for OWNER");
	
	OSFlashBridgeGenericFriends(opensocial.IdSpec.PersonId.OWNER, function(arrFriends)
	{
		OSFlashBridgeFlashDispatcher("onOwnerFriends", arrFriends);
	});
}

function OSFlashBridgeFriends(userid)
{
	trace("OSFlashBridgeFriends for " + userid);
	
  	OSFlashBridgeGenericFriends("userid", function(arrFriends)
	{
		OSFlashBridgeFlashDispatcher("onFriends", arrFriends);
	});	
}

function OSFlashBridgeGenericFriends(userid, callback) 
{
	trace("OSFlashBridgeGenericFriends (" + userid + ")");
	
	var oReq = opensocial.newDataRequest();
	
	oReq.add(oReq.newFetchPeopleRequest(new opensocial.IdSpec({"userId": userid, "groupId": "FRIENDS"}), oUserProfileParams), "get_friends");
	oReq.send(function(oResp)
	{
		var arrFriends = oResp.get("get_friends").getData().asArray();
		
		inspect(arrFriends);

		callback(arrFriends);
	});
}

function OSFlashBridgePostActivity(actname, keys, title, message)
{
	trace("OSFlashBridgePostActivity (" + actname + ")");
	
	var oParams = {};
	
	message = actname.length > 0 ? new gadgets.Prefs().getMsg(actname) : message;

	// oParams[opensocial.Activity.Field.TITLE_ID] = actname;
	// oParams[opensocial.Activity.Field.TEMPLATE_PARAMS] = keys;

	for(var i in keys)
		message = message.split("${" + i + "}").join(keys[i]);

	oParams[opensocial.Activity.Field.TITLE] = title;
	oParams[opensocial.Activity.Field.BODY] = message;
	
	var oActivity = opensocial.newActivity(oParams); inspect(oActivity);

	opensocial.requestCreateActivity(oActivity, opensocial.CreateActivityPriority.HIGH, function()
  	{
  		trace("OSFlashBridgePostActivity Posted");
  		
  		OSFlashBridgeFlashDispatcher("onActivityPosted");
  	});
}

function OSFlashBridgeSendMessage(title, body, recipients, messagetype, params)
{
	trace("OSFlashBridgeSendMessage");
	
	var oParams = {};

	oParams[opensocial.Message.Field.TYPE] = opensocial.Message.Type.NOTIFICATION; // messagetype
	oParams[opensocial.Message.Field.TITLE] = title;
	oParams[Netlog.Message.Field.PARAMS] = params;
             
	var oMessage = opensocial.newMessage(body, oParams); inspect(oMessage);
	
	opensocial.requestSendMessage(recipients, oMessage, function(oResp)
  	{  		
  		if(oResp.hadError())
  		{ 
  			trace(oResp.getErrorMessage()); 
  			
  			OSFlashBridgeFlashDispatcher("onMessageSentFailed");
  		} 
  		else
  		{
  			trace("OSFlashBridgeSendMessage Sent");
  			  		
	  		OSFlashBridgeFlashDispatcher("onMessageSent");
	  	}
  	});
}

function OSFlashBridgeAddData(userid, key, value)
{
	trace("OSFlashBridgeAddData"); 
	
	var oReq = opensocial.newDataRequest();
	
  	oReq.add(oReq.newUpdatePersonAppDataRequest(userid, key, value));
  	oReq.send(function(oResp)
  	{
		if(oResp.hadError()) 
		{
			trace("OSFlashBridgeAddData Error : " + oResp.getError());
		
			OSFlashBridgeFlashDispatcher("onAppDataSaveFailed");
		}
		else
		{
			trace("OSFlashBridgeAddData Saved");
		
			OSFlashBridgeFlashDispatcher("onAppDataSave");
		}
  	});
}

function OSFlashBridgeGetData(userid, keys)
{
	trace("OSFlashBridgeGetData");
	
	var oReq = opensocial.newDataRequest();
	
  	oReq.add(oReq.newFetchPersonAppDataRequest(userid, keys), "app_data"); inspect(oReq);
  	oReq.send(function(oResp)
  	{  		
		var oData = oResp.get("app_data");
		
		if(oData.hadError()) 
		{
			trace("OSFlashBridgeGetData Error : " + oData.getError());
		
			OSFlashBridgeFlashDispatcher("onAppDataFetchFailed");
		}
		else
		{
			trace("OSFlashBridgeGetData Fetched");
		
			OSFlashBridgeFlashDispatcher("onAppDataFetch", oData.getData());
		}
  	});
}

function OSFlashBridgeGetParam(param)
{
	trace("OSFlashBridgeGetParam " + oURLParams[param]);
	
	var sData = oURLParams[param] == undefined ? "" : oURLParams[param];
	
	OSFlashBridgeFlashDispatcher("onParamFetch", sData);
}

//***********************************************************************************************************//	
