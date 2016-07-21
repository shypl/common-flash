package org.shypl.common.collection {
	import org.shypl.common.lang.RuntimeException;
	
	public class NoSuchElementException extends RuntimeException {
		public function NoSuchElementException(message:String = null) {
			super(message);
		}
	}
}
