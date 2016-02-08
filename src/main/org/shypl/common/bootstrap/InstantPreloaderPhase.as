package org.shypl.common.bootstrap {
	public class InstantPreloaderPhase extends PreloaderPhase {
		public function InstantPreloaderPhase(name:String, totalFinalProgressPercent:int) {
			super(name, totalFinalProgressPercent);
		}

		override public function get completed():Boolean {
			return true;
		}

		override public final function get percent():Number {
			return 1;
		}
	}
}
