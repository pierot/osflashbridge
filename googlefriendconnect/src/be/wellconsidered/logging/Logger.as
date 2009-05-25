/**
* @author 	Pieter Michels
*/

package be.wellconsidered.logging 
{
	//import be.wellconsidered.logging.events.LoggerEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.Event;
	
	public class Logger
	{
		private static var _loggings:Array = new Array();
		private static var _isverbose:Boolean = false;
		
		private static var eventDispatcher:EventDispatcher;
		
		public static function log(sMessage:*, isTrackable:Boolean = false):void
		{
			var trace_arg:String = new Date().toLocaleTimeString() + " : " + sMessage;
			
			_loggings.push(trace_arg);
			
			if(!eventDispatcher)
				eventDispatcher = new EventDispatcher();
			
			if(_isverbose)
				trace(trace_arg);
				
			//if(isTrackable)
				//dispatchEvent(new LoggerEvent(LoggerEvent.TRACK, false, false, convertSpaces(sMessage)));
		}
		
		public static function convertSpaces(sMessage:String):String
		{
			var ptrnSpace:RegExp = / /gi;
			
			return sMessage.replace(ptrnSpace, "_");
		}
		
		public static function getStack():void
		{
			try { throw(new Error()); } catch (e:Error) { trace(e.getStackTrace()); }
		}
		
		public static function printAll():void
		{
			for(var i:int = 0; i < _loggings.length; i++)
				trace(_loggings[i]);
		}

		/**
		* Getters / Setters
		*/
		public static function get isVerbose():Boolean { return _isverbose; }		
		public static function set isVerbose( value:Boolean ):void { _isverbose = value; }		
		
		/**
		* Eventdispatcher 
		*/
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0):void { eventDispatcher.addEventListener(type, listener, useCapture, priority); }
		public static function dispatchEvent(event:Event):Boolean { return eventDispatcher.dispatchEvent(event); }
		public static function hasEventListener(type:String):Boolean { return eventDispatcher.hasEventListener(type); }
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void { eventDispatcher.removeEventListener(type, listener, useCapture); }
		public static function willTrigger(type:String):Boolean { return eventDispatcher.willTrigger(type); }
	}
}
