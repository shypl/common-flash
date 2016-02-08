package org.shypl.common.ui.button {
	import flash.events.Event;

	public class ButtonEvent extends Event {
		public static const PRESS:String = "press";

		public function ButtonEvent(type:String) {
			super(type);
		}
	}
}
