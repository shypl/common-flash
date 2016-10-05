package org.shypl.common.lang {
	import flash.utils.getQualifiedClassName;
	
	public class Exception extends Error {
		
		public static function getCorrectString(e:Error):String {
			var string:String = getQualifiedClassName(e);
			
			var name:String = e.name;
			var id:int = e.errorID;
			
			if (name != "Error" || id != 0) {
				string += "(" + name + "#" + id + ")";
			}
			
			var message:String = e.message;
			if (message !== null && message.length !== 0) {
				string += ": " + message;
			}
			
			return string;
		}
		
		public static function getCorrectStackTrace(e:Error):String {
			return e is Exception ? e.getStackTrace() : doCorrectStackTrace(e, e.getStackTrace());
		}
		
		private static function doCorrectStackTrace(e:Error, stackTrace:String):String {
			if (stackTrace === null || stackTrace.length === 0 || stackTrace === "null") {
				stackTrace = getCorrectString(e);
			}
			else {
				stackTrace = stackTrace.replace(/^[^\n\r]+/, getCorrectString(e));
			}
			
			if (e is Exception) {
				var cause:Error = Exception(e).cause;
				if (cause !== null) {
					stackTrace += "\nCaused by: " + getCorrectStackTrace(cause);
				}
			}
			
			return stackTrace;
		}
		
		private var _cause:Error;
		
		public function Exception(message:String = null, cause:Error = null) {
			super(message === null ? "" : message);
			this._cause = cause;
		}
		
		public function get cause():Error {
			return _cause;
		}
		
		override public function getStackTrace():String {
			return doCorrectStackTrace(this, super.getStackTrace());
		}
		
		public function toString():String {
			return getCorrectString(this);
		}
	}
}
