package org.shypl.common.lang {
	public class RuntimeException extends Exception {
		public function RuntimeException(message:String = null, cause:Error = null) {
			super(message, cause);
		}
	}
}
