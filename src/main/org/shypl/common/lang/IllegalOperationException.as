package org.shypl.common.lang {
	public class IllegalOperationException extends RuntimeException {
		public function IllegalOperationException(message:String = null, cause:Error = null) {
			super(message, cause);
		}
	}
}
