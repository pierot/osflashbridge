package be.wellconsidered.apis.nlbridge
{
	import be.wellconsidered.apis.nlbridge.data.NLMessageTypes;
	import be.wellconsidered.apis.nlbridge.data.NLUser;
	import be.wellconsidered.apis.nlbridge.events.NLBridgeEvents;
	import be.wellconsidered.logging.Logger;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.external.ExternalInterface;
	import flash.system.Security;

	public class NLBridge extends EventDispatcher
	{
		public static var OWNER:String = "Owner";
		public static var VIEWER:String = "Viewer";
		
		private var _nlUser:NLUser;
		
		public function NLBridge()
		{
			super();
			
			addExternalInterfaces();
			
			ExternalInterface.call("NLFlashBridgeFlashReady");
		}
		 
		private function addExternalInterfaces():void
		{
			ExternalInterface.addCallback("onInit", onInit);
			
			ExternalInterface.addCallback("onCurrentUser", onCurrentUser);
			
			ExternalInterface.addCallback("onUserProfile", onUserProfile);
			
			ExternalInterface.addCallback("onFriends", onFriends);
			
			ExternalInterface.addCallback("onActivityPosted", onActivityPosted);
			
			ExternalInterface.addCallback("onMessageSent", onMessageSent);
			ExternalInterface.addCallback("onMessageSentFailed", onMessageSentFailed);
		}
		
		private function onInit():void
		{
			dispatchEvent(new NLBridgeEvents(NLBridgeEvents.INIT, false, false));
		}
		
		private function onCurrentUser(oUser:Object):void
		{
			_nlUser = new NLUser(oUser);
			
			dispatchEvent(new NLBridgeEvents(NLBridgeEvents.CURRENT_USER, false, false));
		}
		
		private function onUserProfile(oUser:Object):void
		{
			dispatchEvent(new NLBridgeEvents(NLBridgeEvents.USER_PROFILE, false, false, new NLUser(oUser)));
		}
		
		private function onFriends(arrFriends:Array):void
		{
			dispatchEvent(new NLBridgeEvents(NLBridgeEvents.FRIENDS, false, false, arrFriends));
		}
		
		private function onActivityPosted():void
		{
			dispatchEvent(new NLBridgeEvents(NLBridgeEvents.ACTIVITY_POSTED, false, false));
		}
		
		private function onMessageSent():void
		{
			dispatchEvent(new NLBridgeEvents(NLBridgeEvents.MESSAGE_SENT, false, false));
		}
		
		private function onMessageSentFailed():void
		{
			dispatchEvent(new NLBridgeEvents(NLBridgeEvents.MESSAGE_SENT_FAILED, false, false));
		}
		
		/**
		 * Get User Type
		 * 
		 * Returns	OWNER or VIEWER
		 */
		public function getUserType():String
		{
			return _nlUser.isOwner ? NLBridge.OWNER : NLBridge.VIEWER;
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
		public function postActivity(actname:String):void
		{
			Logger.log("Post '" + actname + "' Activity");
			
			if(_nlUser)
				ExternalInterface.call("NLFlashBridgePostActivity", actname);
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
		public function sendMessage(titel:String, body:String, recipients:*, messageType:String = NLMessageTypes.EMAIL):void
		{
			Logger.log("Send Message as " + messageType);
			
			if(_nlUser)
				ExternalInterface.call("NLFlashBridgeSendMessage", titel, body, recipients, messageType);
			else
				throw new Error("No user connected");
		}
		
		/**
		 * Get Current User Object
		 */
		public function get nluser():NLUser
		{
			return _nlUser;
		}
	}
}