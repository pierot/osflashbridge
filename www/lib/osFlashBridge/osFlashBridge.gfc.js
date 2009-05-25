var securityToken = "";

//***********************************************************************************************************//	

function GFCFlashBridgeFetchToken() { 
	return securityToken; 
}

function GFCFlashBridgeTokenFetched(st) { 
	trace("GFCFlashBridgeTokenFetched (" + st + ")");

	securityToken = st;
	
	if(oFlash)
		oFlash.onTokenFetched(securityToken);
}

function GFCFlashBridgeFlashReady() {
	trace("GFCFlashBridgeFlashReady");
	
	oFlash = swfobject.getObjectById("flash_flash");
	
	if(securityToken.length > 0)
		oFlash.onTokenFetched(securityToken);
}

function GFCFlashBridgeSignOut() {  
	trace("GFCFlashBridgeSignOut");
	
	google.friendconnect.requestSignOut();
}

function GFCFlashBridgeSignIn() {  
	trace("GFCFlashBridgeSignIn (" + securityToken + ")");
	
	// if(securityToken.length > 0) { // WILL ONLY BE CALLED IF JAVASCRIPT WAS QUICKER THAN FLASH OR USER WAS ALREADY SIGNED IN FROM PREVIOUS SESSION
	//	oFlash.onTokenFetched(securityToken);
	// } else {
		google.friendconnect.requestSignIn();
	// }
}

//***********************************************************************************************************//	
