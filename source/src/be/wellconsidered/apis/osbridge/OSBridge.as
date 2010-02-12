package be.wellconsidered.apis.osbridge {
	import be.wellconsidered.apis.osbridge.data.OSMessage;
	import be.wellconsidered.apis.osbridge.data.OSUser;
	import be.wellconsidered.apis.osbridge.events.OSBridgeEvents;

	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class OSBridge extends EventDispatcher {
		public static var OWNER:String = "Owner";
		public static var VIEWER:String = "Viewer";

		private var _osUser:OSUser;
		private var _osOwner:OSUser;

		public function OSBridge() {
			super();

			addExternalInterfaces();
		}

		public function init():void {
			ExternalInterface.call("OSFlashBridgeFlashReady");
		}

		private function addExternalInterfaces():void {
			ExternalInterface.addCallback("onInit", onInit);

			ExternalInterface.addCallback("onOwner", onOwner);
			ExternalInterface.addCallback("onOwnerNotLoggedIn", onOwnerNotLoggedIn);

			ExternalInterface.addCallback("onCurrentUser", onCurrentUser);
			ExternalInterface.addCallback("onCurrentUserNotLoggedIn", onCurrentUserNotLoggedIn);

			ExternalInterface.addCallback("onUserProfile", onUserProfile);
			ExternalInterface.addCallback("onUserProfileError", onUserProfileError);

			ExternalInterface.addCallback("onFriends", onFriends);
			ExternalInterface.addCallback("onOwnerFriends", onOwnerFriends);

			ExternalInterface.addCallback("onActivityPosted", onActivityPosted);

			ExternalInterface.addCallback("onMessageSent", onMessageSent);
			ExternalInterface.addCallback("onMessageSentFailed", onMessageSentFailed);

			ExternalInterface.addCallback("onAppDataSave", onAppDataSave);
			ExternalInterface.addCallback("onAppDataSaveFailed", onAppDataSaveFailed);

			ExternalInterface.addCallback("onAppDataFetch", onAppDataFetch);
			ExternalInterface.addCallback("onAppDataFetchFailed", onAppDataFetchFailed);

			ExternalInterface.addCallback("onParamFetch", onParamFetch);
		}

		private function onInit():void {
			trace("OSBridge: Init | Object ID '" + ExternalInterface.objectID + "'");

			dispatchEvent(new OSBridgeEvents(OSBridgeEvents.INIT, true, false));
		}

		private function onOwner(oUser:Object):void {
			_osOwner = new OSUser(oUser);

			dispatchEvent(new OSBridgeEvents(OSBridgeEvents.OWNER, true, false));
		}

		private function onCurrentUserNotLoggedIn():void {
			dispatchEvent(new OSBridgeEvents(OSBridgeEvents.CURRENT_USER_NOT_LOGGED_IN, true, false));
		}

		private function onOwnerNotLoggedIn():void {
			dispatchEvent(new OSBridgeEvents(OSBridgeEvents.NOT_LOGGED_IN, true, false));
		}

		private function onCurrentUser(oUser:Object):void {
			_osUser = new OSUser(oUser);

			trace("OSBridge :: onCurrentUser :: " + _osUser);

			dispatchEvent(new OSBridgeEvents(OSBridgeEvents.CURRENT_USER, true, false));
		}

		private function onUserProfile(oUser:Object):void {
			dispatchEvent(new OSBridgeEvents(OSBridgeEvents.USER_PROFILE, true, false, new OSUser(oUser)));
		}

		private function onUserProfileError():void {
			dispatchEvent(new OSBridgeEvents(OSBridgeEvents.USER_PROFILE_ERROR, true, false));
		}

		private function onFriends(arrFriends:Array):void {
			trace("OSBridge :: onFriends :: " + arrFriends);

			dispatchEvent(new OSBridgeEvents(OSBridgeEvents.FRIENDS, true, false, arrFriends));
		}

		private function onOwnerFriends(arrFriends:Array):void {
			dispatchEvent(new OSBridgeEvents(OSBridgeEvents.FRIENDS_OWNER, true, false, arrFriends));
		}

		private function onActivityPosted():void {
			dispatchEvent(new OSBridgeEvents(OSBridgeEvents.ACTIVITY_POSTED, true, false));
		}

		private function onMessageSent():void {
			dispatchEvent(new OSBridgeEvents(OSBridgeEvents.MESSAGE_SENT, true, false));
		}

		private function onMessageSentFailed():void {
			dispatchEvent(new OSBridgeEvents(OSBridgeEvents.MESSAGE_SENT_FAILED, true, false));
		}

		private function onAppDataFetchFailed():void {
			dispatchEvent(new OSBridgeEvents(OSBridgeEvents.APPDATA_FETCH_FAILED, true, false));
		}

		private function onAppDataFetch(data:*):void {
			dispatchEvent(new OSBridgeEvents(OSBridgeEvents.APPDATA_FETCH, true, false, data));
		}

		private function onAppDataSaveFailed():void {
			dispatchEvent(new OSBridgeEvents(OSBridgeEvents.APPDATA_SAVE_FAILED, true, false));
		}

		private function onAppDataSave():void {
			dispatchEvent(new OSBridgeEvents(OSBridgeEvents.APPDATA_SAVE, true, false));
		}

		private function onParamFetch(data:*):void {
			dispatchEvent(new OSBridgeEvents(OSBridgeEvents.PARAMDATA_FETCH, true, false, data));
		}

		/**
		 * Get User Type
		 *
		 * Returns	OWNER or VIEWER
		 */
		public function getUserType():String {
			return _osUser.isOwner ? OSBridge.OWNER : OSBridge.VIEWER;
		}

		/**
		 * Get Current Viewing User
		 *
		 * Returns	nothing
		 */
		public function getCurrentUser():void {
			ExternalInterface.call("OSFlashBridgeCurrentUser");
		}

		/**
		 * Get Owner
		 *
		 * Returns	nothing
		 */
		public function getOwner():void {
			ExternalInterface.call("OSFlashBridgeOwner");
		}

		/**
		 * Get User Profile
		 *
		 * Return nothing
		 */
		public function getUserProfile(userid:String):void {
			ExternalInterface.call("OSFlashBridgeUserProfile", userid);
		}

		/**
		 * Get Friends of user
		 *
		 * Return nothing
		 */
		public function getFriends(userid:String):void {
			ExternalInterface.call("OSFlashBridgeFriends", userid);
		}

		/**
		 * Get Friends of owner / site
		 *
		 * Return nothing
		 */
		public function getOwnerFriends():void {
			ExternalInterface.call("OSFlashBridgeOwnerFriends");
		}

		/**
		 * Post Activity
		 *
		 * @actname		Name of activity template
		 *
		 * Return nothing
		 */
		public function postActivity(actname:String, keys:Object = null, title:String = "", message:String = ""):void {
			ExternalInterface.call("OSFlashBridgePostActivity", actname, keys ? keys : {}, title, message);
		}

		/**
		 * Send Message
		 *
		 * @messageType		NLMessageTypes
		 *
		 * Return nothing
		 */
		public function sendMessage(osmessage:OSMessage, recipients:*):void {
			// navigateToURL(new URLRequest("javascript: alert('sendmessage')"), "_self");

			// ExternalInterface.call("OSFlashBridgeSendMessage"); // , osmessage.title, osmessage.body, recipients, osmessage.messagetype, osmessage.params);
			ExternalInterface.call("OSFlashBridgeSendMessage", osmessage.title, osmessage.body, recipients, osmessage.messagetype, osmessage.params);
		}

		/**
		 * Save App Data for UserID
		 *
		 * Return nothing
		 */
		public function saveAppData(userid:String, key:String, value:*):void {
			ExternalInterface.call("OSFlashBridgeAddData", userid, key, value);
		}

		/**
		 * Fetch App Data for UserID
		 *
		 * Return nothing
		 */
		public function fetchAppData(userid:String, keys:*):void {
			ExternalInterface.call("OSFlashBridgeGetData", userid, keys);
		}

		/**
		 * Fetch Param variables
		 *
		 * Return nothing
		 */
		public function fetchParamData(param:String):void {
			ExternalInterface.call("OSFlashBridgeGetParam", param);
		}

		/**
		 * Set Current User Object
		 */
		public function set viewer(value:OSUser):void {
			_osUser = value;
		}

		/**
		 * Get Current User Object
		 */
		public function get viewer():OSUser {
			return _osUser;
		}

		/**
		 * Get Current User Object
		 */
		public function get owner():OSUser {
			return _osOwner;
		}
	}
}