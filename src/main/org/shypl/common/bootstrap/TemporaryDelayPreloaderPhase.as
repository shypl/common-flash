package org.shypl.common.bootstrap {
	import flash.utils.getTimer;

	import org.shypl.common.lang.AbstractMethodException;

	[Abstract]
	public class TemporaryDelayPreloaderPhase extends PreloaderPhase {
		private var _delay:int;
		private var _startTime:int;
		private var _completed:Boolean;

		public function TemporaryDelayPreloaderPhase(name:String, totalFinalProgressPercent:int, delaySeconds:int) {
			super(name, totalFinalProgressPercent);
			_delay = delaySeconds * 1000;
		}

		override public function get completed():Boolean {
			return _completed;
		}

		override final public function get percent():Number {
			if (completed) {
				return 1;
			}

			var passedTime:int = getTimer() - _startTime;
			if (passedTime >= _delay) {
				return 0.99;
			}

			return passedTime / _delay * 0.99;
		}

		override final public function start():void {
			_startTime = getTimer();
			doStart();
		}

		[Abstract]
		protected function doStart():void {
			throw new AbstractMethodException();
		}

		protected function complete():void {
			_completed = true;
		}
	}
}
