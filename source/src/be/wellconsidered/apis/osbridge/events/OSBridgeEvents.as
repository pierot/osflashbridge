package be.wellconsidered.apis.osbridge.events
{
	import flash.events.Event;

	public class OSBridgeEvents extends Event
	{
		public static var INIT:String = "Init";
		
		public static var NOT_LOGGED_IN:String = "NotLoggedIn";
		
		public static var OWNER:String = "Owner";
		
		public static var CURRENT_USER:String = "CurrentUser";
		public static var CURRENT_USER_NOT_LOGGED_IN:String = "CurrentUserNotLoggedIn";
		
		public static var USER_PROFILE:String = "UserProfile";
		public static var USER_PROFILE_ERROR:String = "UserProfileError";
		
		public static var ACTIVITY_POSTED:String = "ActivityPosted";
		
		public static var MESSAGE_SENT:String = "MessageSent";
		public static var MESSAGE_SENT_FAILED:String = "MessageSentFailed";
		
		public static var APPDATA_FETCH:String = "AppDataFetch";
		public static var APPDATA_FETCH_FAILED:String = "AppDataFetchFailed";
		
		public static var APPDATA_SAVE:String = "AppDataSave";
		public static var APPDATA_SAVE_FAILED:String = "AppDataSaveFailed";
		
		public static var PARAMDATA_FETCH:String = "ParamDataFetch";
		
		public static var FRIENDS:String = "Friends";
		public static var FRIENDS_OWNER:String = "FriendsOwner";
		
		private var _data:* = null;
		
		public function OSBridgeEvents(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:*=null)
		{
			super(type, bubbles, cancelable);
			
			_data = data;
		}
		
		public function get data():*
		{
			return _data;
		}
	}
}