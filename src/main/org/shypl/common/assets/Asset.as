package org.shypl.common.assets {
	import flash.events.IEventDispatcher;

	[Event(name="complete", type="flash.events.Event")]
	public interface Asset extends IEventDispatcher {
		function get loaded():Boolean;

		function get path():String;
	}
}
