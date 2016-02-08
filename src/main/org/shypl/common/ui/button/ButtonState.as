package org.shypl.common.ui.button {
	import org.shypl.common.lang.Enum;

	public final class ButtonState extends Enum {
		public static const NORMAL:ButtonState = new ButtonState("NORMAL");
		public static const HOVER:ButtonState = new ButtonState("HOVER");
		public static const ACTIVE:ButtonState = new ButtonState("ACTIVE");
		public static const DISABLED:ButtonState = new ButtonState("DISABLED");

		public function ButtonState(name:String) {
			super(name);
		}
	}
}
