package be.wellconsidered.apis.googlefriendconnect.events
{
	import flash.events.Event;

	public class GoogleFriendConnectEvent extends Event
	{
		public static var INITED:String = "Inited";
		public static var CONNECTED:String = "Connected";
		public static var DISCONNECTED:String = "DisConnected";
		
		private static var _data:*;
		
		public function GoogleFriendConnectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:*=null)
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