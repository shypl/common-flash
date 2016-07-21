package org.shypl.common.collection {
	import org.shypl.common.lang.RuntimeException;
	
	public class ConcurrentModificationException extends RuntimeException {
		public function ConcurrentModificationException() {
		}
	}
}
