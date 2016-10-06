package org.shypl.common.lang {
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	public class EventException extends RuntimeException {
		private var _event:Event;
		
		public function EventException(event:Event, message:String = null) {
			super(message === null ? (getQualifiedClassName(event) + "#" + event.type) : message);
			_event = event;
		}
		
		public function get event():Event {
		return _event;
	}
		
		override public function getStackTrace():String {
			return super.getStackTrace()
				+ "\nCaused by: " + getQualifiedClassName(_event) + "#" + _event.type
				+ "\n  info: " + _event.toString()
				+ "\n  target: " + getQualifiedClassName(_event.target) + ": " + String(_event.target)
		}
	}
}
