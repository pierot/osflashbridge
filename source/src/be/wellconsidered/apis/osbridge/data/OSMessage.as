package be.wellconsidered.apis.osbridge.data
{
	import be.wellconsidered.apis.osbridge.constants.OSMessageTypes;
	
	public class OSMessage
	{
		private var _sTitle:String = "";
		private var _sBody:String = "";
		private var _sMessageType:String = "";
		private var _oParams:Object = null;
		
		public function OSMessage(titel:String, body:String, messageType:String = "", params:Object = null)
		{
			_sTitle = title;
			_sBody = body;
			_sMessageType = messageType.length == 0 ? OSMessageTypes.EMAIL : messageType;
			_oParams = params ? params : {};
		}

		public function get title():String{ return _sTitle; }
		public function get body():String{ return _sBody; }
		public function get messagetype():String{ return _sMessageType; }
		public function get params():Object{ return _oParams; }
	}
}