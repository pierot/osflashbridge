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

gadgets.util.registerOnLoadHandler(osInit);

function osInit() 
{
	oEnv = opensocial.getEnvironment();
	oURL = gadgets.util.getUrlParameters();
	oURLParams = gadgets.views.getParams();
	
	NLFlashBridgeInit();
	
	// gadgets.window.adjustHeight();
	
	// opensocial.requestPermission(permissions, reason, opt_callback);
	// opensocial.Enum.Gender
}

//***********************************************************************************************************//	

function NLFlashBridgeInit()
{
	trace("NLFlashBridgeInit");
	
	// SETTINGS
	sDomain = oEnv.getDomain();
	
	oUserProfileParams = {};
	oUserProfileParams[opensocial.DataRequest.PeopleRequestFields.PROFILE_DETAILS] = [opensocial.Person.Field.GENDER];
	// oUserProfileParams[opensocial.DataRequest.PeopleRequestFields.PROFILE_DETAILS] = [opensocial.Person.Field.EMAILS];
	
	// trace(oEnv.supportsField(opensocial.Environment.ObjectType.PERSON, opensocial.Person.Field.EMAILS)); // false
	// trace(oEnv.supportsField(opensocial.Environment.ObjectType.MESSAGE_TYPE, opensocial.Message.Field.EMAILS)); // false
	
	inspect(oURLParams);
}

function NLFlashBridgeFlashReady()
{
	trace("NLFlashBridgeFlashReady");
	
	oFlash = swfobject.getObjectById("flash_flash");
	isFlashReady = true;
	
	NLFlashBridgeFlashDispatcher("onInit");
}

function NLFlashBridgeCountry()
{
	trace("NLFlashBridgeCountry is " + gadgets.Prefs.getCountry());
}

function NLFlashBridgeLanguage()
{
	trace("NLFlashBridgeLanguage is " + gadgets.Prefs.getLang());
}

function NLFlashBridgeOwner()
{
	trace("NLFlashBridgeOwner");
	
	NLFlashBridgeGenericUserProfile(opensocial.IdSpec.PersonId.OWNER, function(oUser)
	{
		oOwner = oUser;
		
		NLFlashBridgeFlashDispatcher("onOwner", oUser);
	});
}

function NLFlashBridgeCurrentUser() 
{
	trace("NLFlashBridgeCurrentUser");
	
	NLFlashBridgeGenericUserProfile(opensocial.IdSpec.PersonId.VIEWER, function(oUser)
	{
		oViewer = oUser;
		
		NLFlashBridgeFlashDispatcher("onCurrentUser", oUser);
	});
}

function NLFlashBridgeUserProfile(userid) 
{
	trace("NLFlashBridgeUserProfile");
	
	NLFlashBridgeGenericUserProfile(userid, function(oUser)
	{
		NLFlashBridgeFlashDispatcher("onUserProfile", oUser);
	});
}

function NLFlashBridgeGenericUserProfile(userid, callback) 
{
	trace("NLFlashBridgeGenericUserProfile");
	
	var req = opensocial.newDataRequest();
	
	req.add(req.newFetchPersonRequest(userid, oUserProfileParams), "user");
	req.send(function(oResp)
	{
		var oUserResp = oResp.get("user");
		var oUser = oUserResp.getData(); inspect(oUser);

		callback(oUser);
	});
}

function NLFlashBridgeFriends(userid)
{
	trace("NLFlashBridgeFriends for " + userid);
	
  	var oReq = opensocial.newDataRequest();
  	
  	oReq.add(oReq.newFetchPeopleRequest(opensocial.newIdSpec({"userId": userid, "groupId": "FRIENDS"}), oUserProfileParams), "get_friends");
	oReq.send(function(oResp)
	{
		var arrFriends = oResp.get('get_friends').getData(); 
		
		// inspect(arrFriends);
		
		NLFlashBridgeFlashDispatcher("onFriends", arrFriends.array_);
	});
}

function NLFlashBridgePostActivity(actname, keys, title, message)
{
	trace("NLFlashBridgePostActivity (" + actname + ")");
	
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
  		trace("NLFlashBridgePostActivity Posted");
  		
  		NLFlashBridgeFlashDispatcher("onActivityPosted");
  	});
}

function NLFlashBridgeSendMessage(title, body, recipients, messagetype, params)
{
	trace("NLFlashBridgeSendMessage");
	
	var oParams = {};
	inspect(Netlog);
	oParams[Netlog.Message.Field.TYPE] = Netlog.Message.Type.NOTIFICATION;
	oParams[Netlog.Message.Field.TITLE] = title;
	oParams[Netlog.Message.Field.PARAMS] = params;
             
	var oMessage = Netlog.newMessage(body, oParams); inspect(oMessage);
	
	Netlog.requestSendMessage(recipients, oMessage, function(oResp)
  	{  		
  		if(oResp.hadError())
  		{ 
  			trace(oResp.getErrorMessage()); 
  			
  			NLFlashBridgeFlashDispatcher("onMessageSentFailed");
  		} 
  		else
  		{
  			trace("NLFlashBridgeSendMessage Sent");
  			  		
	  		NLFlashBridgeFlashDispatcher("onMessageSent");
	  	}
  	});
	
	/*
	oParams[opensocial.Message.Field.TYPE] = messagetype;
	oParams[opensocial.Message.Field.TITLE] = title;
	
	var oMessage = opensocial.newMessage(body, oParams); inspect(oMessage);
	
	opensocial.requestSendMessage(recipients, oMessage);
  	*/
}

function NLFlashBridgeAddData(userid, key, value)
{
	trace("NLFlashBridgeAddData"); 
	
	var oReq = opensocial.newDataRequest();
	
  	oReq.add(oReq.newUpdatePersonAppDataRequest(userid, key, value));
  	oReq.send(function(oResp)
  	{
     	if(oResp.hadError()) 
     	{
       		trace("NLFlashBridgeAddData Error : " + oResp.getError());
       		
       		NLFlashBridgeDispatcher("onAppDataSaveFailed");
     	}
     	else
     	{
			trace("NLFlashBridgeAddData Saved");
			
			NLFlashBridgeDispatcher("onAppDataSave");
     	}
  	});
}

function NLFlashBridgeGetData(userid, keys)
{
	trace("NLFlashBridgeGetData");
	
	var oReq = opensocial.newDataRequest();
	
  	oReq.add(oReq.newFetchPersonAppDataRequest(userid, keys), "app_data"); inspect(oReq);
  	oReq.send(function(oResp)
  	{  		
  		var oData = oResp.get("app_data");

     	if(oData.hadError()) 
     	{
       		trace("NLFlashBridgeGetData Error : " + oData.getError());
       		
       		NLFlashBridgeDispatcher("onAppDataFetchFailed");
     	}
     	else
     	{
			trace("NLFlashBridgeGetData Fetched");
			
			NLFlashBridgeDispatcher("onAppDataFetch", oData.getData());
     	}
  	});
}

//***********************************************************************************************************//	
