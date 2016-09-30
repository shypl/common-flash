package org.shypl.common.loader {
	import org.shypl.common.lang.RuntimeException;
	
	public class FileLoaderException extends RuntimeException {
		public function FileLoaderException(message:String = null, cause:Error = null) {
			super(message, cause);
		}
	}
}
