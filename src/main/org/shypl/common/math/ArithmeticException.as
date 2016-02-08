package org.shypl.common.math {
	import org.shypl.common.lang.RuntimeException;

	public class ArithmeticException extends RuntimeException {
		public function ArithmeticException(message:String = null, cause:Error = null) {
			super(message, cause);
		}
	}
}
