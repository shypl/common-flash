package org.shypl.common.lang {
	public interface UncaughtErrorHandler {
		function isPreventDefault():Boolean;
		
		function catchError(error:Error):void;
	}
}
