package org.shypl.common.lang {
	import flash.events.ErrorEvent;
	
	public class ErrorEventException extends EventException {
		public function ErrorEventException(event:ErrorEvent, message:String = null) {
			super(event, message);
		}
		
		public function get errorEvent():ErrorEvent {
			return super.event as ErrorEvent;
		}
	}
}
