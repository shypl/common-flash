package org.shypl.common.lang {
	import flash.events.ErrorEvent;

	public interface UncaughtErrorHandler {
		function isPreventDefault():Boolean;

		function catchError(error:Error):void;

		function catchObject(error:Object):void;

		function catchEvent(error:ErrorEvent):void;
	}
}
