package org.shypl.common.lang {
	public class IllegalArgumentException extends RuntimeException {
		public function IllegalArgumentException(message:String = null, cause:Error = null) {
			super(message, cause);
		}
	}
}
