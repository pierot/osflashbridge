package be.wellconsidered.logging.events
{
	import flash.events.Event;

	public class LoggerEvent extends Event
	{
		public static const TRACK:String = "Track";
		public static const DEBUG:String = "Debug";
		
		private var _data:*;
		
		public function LoggerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:*=null)
		{
			super(type, bubbles, cancelable);
			
			_data = data;
		}
		
		public function get data():* { return _data; }
	}
}