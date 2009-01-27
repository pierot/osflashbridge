/**
 * @author 	Pieter Michels
 */

package be.wellconsidered.logging
{	
	public class Logger
	{
		private static var _loggings:Array = new Array();
		private static var _isverbose:Boolean = false;
		
		public static function log(sMessage:*):void
		{
			var trace_arg:String = new Date().toLocaleTimeString() + " : " + sMessage;
			
			if(_isverbose)
				trace(trace_arg);
		}
		
		public static function getStack():void
		{
			try { throw(new Error()); } catch (e:Error) { trace(e.getStackTrace()); }
		}

		/**
		* Getters / Setters
		*/
		public static function get isVerbose():Boolean { return _isverbose; }		
		public static function set isVerbose( value:Boolean ):void { _isverbose = value; }		
	}
}
