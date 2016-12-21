package org.shypl.common.logging {
	public interface Logger {
		function isErrorEnabled():Boolean;
		
		function isWarnEnabled():Boolean;
		
		function isInfoEnabled():Boolean;
		
		function isDebugEnabled():Boolean;
		
		function isTraceEnabled():Boolean;
		
		function isEnabled(level:Level):Boolean;
		
		function error(message:String, ...args):void;
		
		function warn(message:String, ...args):void;
		
		function info(message:String, ...args):void;
		
		function debug(message:String, ...args):void;
		
		function trace(message:String, ...args):void;
		
		function log(level:Level, message:String, args:Array):void;
	}
}
