var securityToken = "";

//***********************************************************************************************************//	

function GFCFlashBridgeFetchToken() { 
	return securityToken; 
}

function GFCFlashBridgeTokenFetched(st) { 
	trace("GFCFlashBridgeTokenFetched (" + st + ")");

	if(securityToken.length == 0) {
		securityToken = st;
	
		if(oFlash)
			oFlash.onGFCTokenFetched(securityToken);
	}
		
	GFCFlashBridgeGetLoggedInUser();
}

function GFCFlashBridgeFlashReady() {
	trace("GFCFlashBridgeFlashReady");
	
	oFlash = swfobject.getObjectById("flash_flash");
	
	if(securityToken.length > 0)
		oFlash.onGFCTokenFetched(securityToken);
		
	GFCFlashBridgeGetLoggedInUser();
}

function GFCFlashBridgeGetLoggedInUser() {
	trace("GFCFlashBridgeGetLoggedInUser");

	OSFlashBridgeGenericUserProfile(opensocial.IdSpec.PersonId.VIEWER, function(oUser) {
		if(oUser) {
			trace("GFCFlashBridgeGetLoggedInUser LOGGED IN");
			
			oViewer = oUser;
			
			oFlash.onGFCConnected(oViewer);
		}
		else
			trace("GFCFlashBridgeGetLoggedInUser NOT LOGGED IN");
	});
}

function GFCFlashBridgeSignOut() {  
	trace("GFCFlashBridgeSignOut");
	
	securityToken = "";
	oViewer = null;
	
	google.friendconnect.requestSignOut();
}

function GFCFlashBridgeSignIn() {  
	trace("GFCFlashBridgeSignIn (" + securityToken + ")");
	
	if(oViewer)
		oFlash.onGFCConnected(oViewer);
	else
		google.friendconnect.requestSignIn();
}

//***********************************************************************************************************//	
