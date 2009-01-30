package be.wellconsidered.apis.nlbridge.events
{
	import flash.events.Event;

	public class OSBridgeEvents extends Event
	{
		public static var INIT:String = "Init";
		
		public static var OWNER:String = "Owner";
		
		public static var CURRENT_USER:String = "CurrentUser";
		
		public static var USER_PROFILE:String = "UserProfile";
		
		public static var ACTIVITY_POSTED:String = "ActivityPosted";
		
		public static var MESSAGE_SENT:String = "MessageSent";
		public static var MESSAGE_SENT_FAILED:String = "MessageSentFailed";
		
		public static var APPDATA_FETCH:String = "AppDataFetch";
		public static var APPDATA_FETCH_FAILED:String = "AppDataFetchFailed";
		
		public static var APPDATA_SAVE:String = "AppDataSave";
		public static var APPDATA_SAVE_FAILED:String = "AppDataSaveFailed";
		
		public static var FRIENDS:String = "Friends";
		
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