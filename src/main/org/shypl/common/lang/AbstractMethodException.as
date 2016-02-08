package org.shypl.common.lang {
	public class AbstractMethodException extends Exception {
		public function AbstractMethodException() {
			super("Requires the implementation of an abstract method");
		}
	}
}
