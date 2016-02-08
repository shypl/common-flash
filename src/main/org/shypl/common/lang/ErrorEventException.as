package org.shypl.common.lang {
	import flash.events.ErrorEvent;

	public class ErrorEventException extends RuntimeException {
		private var _event:ErrorEvent;

		public function ErrorEventException(event:ErrorEvent, message:String = null) {
			super(message === null ? event.text : message + " (" + event.text + ")");
			_event = event;
		}

		public function get event():ErrorEvent {
			return _event;
		}

		override public function getStackTrace():String {
			return super.getStackTrace() + "\nEvent: " + _event.toString();
		}
	}
}
