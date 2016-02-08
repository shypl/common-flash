package org.shypl.common.util {
	import flash.events.Event;

	public class DestroyEvent extends Event {
		public static const DESTROY:String = "destroy";

		public function DestroyEvent() {
			super(DESTROY);
		}
	}
}
