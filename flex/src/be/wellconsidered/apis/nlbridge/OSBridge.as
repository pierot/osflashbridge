package be.wellconsidered.apis.nlbridge
{
	import be.wellconsidered.apis.nlbridge.constants.OSMessageTypes;
	import be.wellconsidered.apis.nlbridge.data.OSMessage;
	import be.wellconsidered.apis.nlbridge.data.OSUser;
	import be.wellconsidered.apis.nlbridge.events.OSBridgeEvents;
	import be.wellconsidered.logging.Logger;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.external.ExternalInterface;
	import flash.system.Security;

	public class OSBridge extends EventDispatcher
	{
		public static var OWNER:String = "Owner";
		public static var VIEWER:String = "Viewer";
		
		private var _osUser:OSUser;
		private var _osOwner:OSUser;
		
		public function OSBridge()
		{
			super();
			
			addExternalInterfaces();
		}
		
		public function init():void
		{
			ExternalInterface.call("NLFlashBridgeFlashReady");
		}
		 
		private function addExternalInterfaces():void
		{
			ExternalInterface.addCallback("onInit", onInit);
			
			ExternalInterface.addCallback("onOwner", onOwner);
			
			ExternalInterface.addCallback("onCurrentUser", onCurrentUser);
			
			ExternalInterface.addCallback("onUserProfile", onUserProfile);
			
			ExternalInterface.addCallback("onFriends", onFriends);
			
			ExternalInterface.addCallback("onActivityPosted", onActivityPosted);
			
			ExternalInterface.addCallback("onMessageSent", onMessageSent);
			ExternalInterface.addCallback("onMessageSentFailed", onMessageSentFailed);
			
			ExternalInterface.addCallback("onAppDataSave", onAppDataSave);
			ExternalInterface.addCallback("onAppDataSaveFailed", onAppDataSaveFailed);
			
			ExternalInterface.addCallback("onAppDataFetch", onAppDataFetch);
			ExternalInterface.addCallback("onAppDataFetchFailed", onAppDataFetchFailed);
		}
		
		private function onInit():void
		{
			dispatchEvent(new OSBridgeEvents(OSBridgeEvents.INIT, false, false));
		}
		
		private function onOwner(oUser:Object):void
		{
			_osOwner = new OSUser(oUser);
			
			dispatchEvent(new OSBridgeEvents(OSBridgeEvents.OWNER, false, false));
		}
		
		private function onCurrentUser(oUser:Object):void
		{
			_osUser = new OSUser(oUser);
			
			dispatchEvent(new OSBridgeEvents(OSBridgeEvents.CURRENT_USER, false, false));
		}
		
		private function onUserProfile(oUser:Object):void
		{
			dispatchEvent(new OSBridgeEvents(OSBridgeEvents.USER_PROFILE, false, false, new OSUser(oUser)));
		}
		
		private function onFriends(arrFriends:Array):void
		{
			dispatchEvent(new OSBridgeEvents(OSBridgeEvents.FRIENDS, false, false, arrFriends));
		}
		
		private function onActivityPosted():void
		{
			dispatchEvent(new OSBridgeEvents(OSBridgeEvents.ACTIVITY_POSTED, false, false));
		}
		
		private function onMessageSent():void
		{
			dispatchEvent(new OSBridgeEvents(OSBridgeEvents.MESSAGE_SENT, false, false));
		}
		
		private function onMessageSentFailed():void
		{
			dispatchEvent(new OSBridgeEvents(OSBridgeEvents.MESSAGE_SENT_FAILED, false, false));
		}
		
		private function onAppDataFetchFailed():void
		{
			dispatchEvent(new OSBridgeEvents(OSBridgeEvents.APPDATA_FETCH_FAILED, false, false));
		}
		
		private function onAppDataFetch(data:*):void
		{
			dispatchEvent(new OSBridgeEvents(OSBridgeEvents.APPDATA_FETCH, false, false, data));
		}
		
		private function onAppDataSaveFailed():void
		{
			dispatchEvent(new OSBridgeEvents(OSBridgeEvents.APPDATA_SAVE_FAILED, false, false));
		}
		
		private function onAppDataSave():void
		{
			dispatchEvent(new OSBridgeEvents(OSBridgeEvents.APPDATA_SAVE, false, false));
		}
		
		/**
		 * Get User Type
		 * 
		 * Returns	OWNER or VIEWER
		 */
		public function getUserType():String
		{
			return _osUser.isOwner ? OSBridge.OWNER : OSBridge.VIEWER;
		}
		
		/**
		 * Get Current Viewing User
		 * 
		 * Returns	nothing
		 */
		public function getCurrentUser():void
		{
			Logger.log("Get Current User");
			
			ExternalInterface.call("NLFlashBridgeCurrentUser");
		}
		
		/**
		 * Get Owner
		 * 
		 * Returns	nothing
		 */
		public function getOwner():void
		{
			Logger.log("Get Owner");
			
			ExternalInterface.call("NLFlashBridgeOwner");
		}
		
		/**
		 * Get User Profile
		 * 
		 * Return nothing
		 */
		public function getUserProfile(userid:String):void
		{
			Logger.log("Get User Profile for " + userid);
			
			ExternalInterface.call("NLFlashBridgeUserProfile", userid);
		}
		
		/**
		 * Get Friends of user
		 * 
		 * Return nothing
		 */
		public function getFriends(userid:String):void
		{
			Logger.log("Get Friends for " + userid);
			
			ExternalInterface.call("NLFlashBridgeFriends", userid);
		}
		
		/**
		 * Post Activity
		 * 
		 * @actname		Name of activity template
		 * 
		 * Return nothing
		 */
		public function postActivity(actname:String, keys:Object = null, title:String = "", message:String = ""):void
		{
			Logger.log("Post '" + actname + "' Activity");
			
			if(_osUser)
				ExternalInterface.call("NLFlashBridgePostActivity", actname, keys ? keys : {}, title, message);
			else
				throw new Error("No user connected");
		}
		
		/**
		 * Send Message
		 * 
		 * @messageType		NLMessageTypes
		 * 
		 * Return nothing
		 */
		public function sendMessage(osmessage:OSMessage, recipients:*):void
		{
			Logger.log("Send Message as " + osmessage.messagetype);
			
			if(_osUser)
				ExternalInterface.call("NLFlashBridgeSendMessage", osmessage.title, osmessage.body, recipients, osmessage.messagetype, osmessage.params);
			else
				throw new Error("No user connected");
		}
		
		/**
		 * Save App Data for UserID
		 * 
		 * Return nothing
		 */
		public function saveAppData(userid:String, key:String, value:*):void
		{
			Logger.log("Save App Data for " + userid);
			
			ExternalInterface.call("NLFlashBridgeAddData", userid, key, value);
		}
		
		/**
		 * Fetch App Data for UserID
		 * 
		 * Return nothing
		 */
		public function fetchAppData(userid:String, keys:*):void
		{
			Logger.log("Fetch App Data for " + userid);
			
			ExternalInterface.call("NLFlashBridgeGetData", userid, keys);
		}
		
		/**
		 * Get Current User Object
		 */
		public function get viewer():OSUser
		{
			return _osUser;
		}
		
		/**
		 * Get Current User Object
		 */
		public function get owner():OSUser
		{
			return _osOwner;
		}
	}
}