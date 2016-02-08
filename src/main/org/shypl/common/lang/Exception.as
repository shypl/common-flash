package org.shypl.common.lang {
	import flash.utils.getQualifiedClassName;

	public class Exception extends Error {
		private var _cause:Error;

		public function Exception(message:String = null, cause:Error = null) {
			super(message === null ? "" : message);
			this._cause = cause;
		}

		public function get cause():Error {
			return _cause;
		}

		override public function getStackTrace():String {
			var str:String = super.getStackTrace();

			if (str === null || str.length === 0 || str === "null") {
				str = toString();
			}

			if (_cause !== null) {
				str += "\nCaused by: " + _cause.getStackTrace();
			}

			return str;
		}

		public function toString():String {
			var str:String = getQualifiedClassName(this);
			if (message !== null && message.length !== 0) {
				str += ": " + message;
			}
			return str;
		}
	}
}
