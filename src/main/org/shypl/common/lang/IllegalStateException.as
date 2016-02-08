package org.shypl.common.lang {
	public class IllegalStateException extends RuntimeException {
		public function IllegalStateException(message:String = null, cause:Error = null) {
			super(message, cause);
		}
	}
}
