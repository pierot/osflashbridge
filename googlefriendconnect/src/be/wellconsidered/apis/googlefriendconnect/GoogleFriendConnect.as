package be.wellconsidered.apis.googlefriendconnect
{
	import be.wellconsidered.apis.googlefriendconnect.events.GoogleFriendConnectEvent;
	
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	
	public class GoogleFriendConnect extends EventDispatcher
	{
		private var _sSecurityToken:String;
		
		public function GoogleFriendConnect()
		{
			addExternalInterfaces();
		}
		
		public function init():void
		{
			ExternalInterface.call("GFCFlashBridgeFlashReady");
		}
		
		private function addExternalInterfaces():void
		{
			ExternalInterface.addCallback("onGFCTokenFetched", onGFCTokenFetched);
			ExternalInterface.addCallback("onGFCConnected", onGFCConnected);
		}
		
		private function onGFCTokenFetched(sSecurityToken:String):void
		{
			_sSecurityToken = sSecurityToken;
			
			dispatchEvent(new GoogleFriendConnectEvent(GoogleFriendConnectEvent.INITED, false, false));
		}
		
		private function onGFCConnected(oViewer:Object):void
		{
			dispatchEvent(new GoogleFriendConnectEvent(GoogleFriendConnectEvent.CONNECTED, false, false, oViewer));
		}
		
		public function connect():void
		{
			ExternalInterface.call("GFCFlashBridgeSignIn");
		}
		
		public function disconnect():void
		{
			ExternalInterface.call("GFCFlashBridgeSignOut");
			
			_sSecurityToken = "";
			
			dispatchEvent(new GoogleFriendConnectEvent(GoogleFriendConnectEvent.DISCONNECTED, false, false));
		}
		
		public function get securitytoken():String
		{
			return _sSecurityToken;
		}
	}
}