package org.shypl.common.assets {
	import flash.events.IEventDispatcher;

	[Event(name="complete", type="flash.events.Event")]
	public interface Asset extends IEventDispatcher {
		function get name():String;

		function get path():String;

		function get loaded():Boolean;
	}
}
