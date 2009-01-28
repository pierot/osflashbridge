var oOwner = null;
var oFlash = null;
var isFlashReady = false;
var oEnv;
var oURL;
var sDomain = "";
var oUserProfileParams;

//***********************************************************************************************************//	

gadgets.util.registerOnLoadHandler(osInit);

function osInit() 
{
	oEnv = opensocial.getEnvironment();
	oURL = gadgets.util.getUrlParameters();
	
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
	
	// trace(oEnv.supportsField(opensocial.Environment.ObjectType.PERSON, opensocial.Person.Field.GENDER));
	// trace(oEnv.supportsField(opensocial.Environment.ObjectType.PERSON, opensocial.Person.Field.EMAILS)); // false
	// trace(oEnv.supportsField(opensocial.Environment.ObjectType.MESSAGE_TYPE, opensocial.Message.Field.EMAILS)); // false
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

function NLFlashBridgeCurrentUser() 
{
	trace("NLFlashBridgeCurrentUser");
	
	NLFlashBridgeGenericUserProfile(opensocial.IdSpec.PersonId.OWNER, function(oUser)
	{
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
	req.send(function(resp)
	{
		var oUserResp = resp.get("user");
		var oUser = oUserResp.getData();

		// inspect(oUser);

		callback(oUser);
	});
}

function NLFlashBridgeFriends(userid)
{
	trace("NLFlashBridgeFriends");
	
  	var req = opensocial.newDataRequest();
  	req.add(req.newFetchPeopleRequest(opensocial.newIdSpec({"userId": userid, "groupId": "FRIENDS"}), oUserProfileParams), "get_friends");
	req.send(function(resp)
	{
		var arrFriends = resp.get('get_friends').getData(); 
		
		// inspect(arrFriends);
		
		NLFlashBridgeFlashDispatcher("onFriends", arrFriends.array_);
	});
}

function NLFlashBridgePostActivity(actname)
{
	trace("NLFlashBridgePostActivity (" + actname + ")");
	
	var sMessage = new gadgets.Prefs().getMsg(actname);
	var params = {};
	var keyvalues = {"URL": "http://www.proximity.bbdo.be", "Subject": oOwner, "Subject.DisplayName": oOwner.getDisplayName()};
	
	// params[opensocial.Activity.Field.TITLE_ID] = actname;
	// params[opensocial.Activity.Field.TEMPLATE_PARAMS] = keyvalues;
	
	for(var i in keyvalues)
		sMessage = sMessage.split("${" + i + "}").join(keyvalues[i]);
	
	params[opensocial.Activity.Field.TITLE] = "NetLog Flash Bridge";
	params[opensocial.Activity.Field.BODY] = sMessage;
	
	var activity = opensocial.newActivity(params); inspect(activity);

	opensocial.requestCreateActivity(activity, opensocial.CreateActivityPriority.HIGH, function()
  	{
  		trace("NLFlashBridgePostActivity Posted");
  		
  		NLFlashBridgeFlashDispatcher("onActivityPosted");
  	});
}

function NLFlashBridgeSendMessage(title, body, recipients, messagetype)
{
	trace("NLFlashBridgeSendMessage");
	
	var params = {};
	
	params[opensocial.Message.Field.TYPE] = messagetype;
	params[opensocial.Message.Field.TITLE] = title;
	
	var message = opensocial.newMessage(body, params); inspect(message);
	
	opensocial.requestSendMessage(recipients, message, function(resp)
  	{  		
  		if(resp.hadError())
  		{ 
  			trace(resp.getErrorMessage()); 
  			
  			NLFlashBridgeFlashDispatcher("onMessageSentFailed");
  		} 
  		else
  		{
  			trace("NLFlashBridgeSendMessage Sent");
  			  		
	  		NLFlashBridgeFlashDispatcher("onMessageSent");
	  	}
  	});
}

//***********************************************************************************************************//	