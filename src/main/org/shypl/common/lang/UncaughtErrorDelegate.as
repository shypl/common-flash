package org.shypl.common.lang {
	import flash.events.ErrorEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.events.UncaughtErrorEvents;

	public final class UncaughtErrorDelegate {
		private static var _handler:UncaughtErrorHandler;

		public static function register(events:UncaughtErrorEvents):void {
			events.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
		}

		public static function unregister(events:UncaughtErrorEvents):void {
			events.removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
		}

		public static function setHandler(handler:UncaughtErrorHandler):void {
			_handler = handler;
		}

		private static function onUncaughtError(event:UncaughtErrorEvent):void {
			if (_handler) {
				if (_handler.isPreventDefault()) {
					event.preventDefault();
				}
				var error:Object = event.error;
				if (error is Error) {
					_handler.catchError(error as Error);
				}
				else if (error is ErrorEvent) {
					_handler.catchEvent(error as ErrorEvent);
				}
				else {
					_handler.catchObject(error);
				}
			}
		}
	}
}
