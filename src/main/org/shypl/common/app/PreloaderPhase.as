package org.shypl.common.app {
	import org.shypl.common.lang.AbstractMethodException;
	import org.shypl.common.util.progress.Progress;

	[Abstract]
	public class PreloaderPhase implements Progress {
		private var _name:String;
		private var _totalFinalProgress:Number;

		public function PreloaderPhase(name:String, totalFinalProgressPercent:int) {
			_name = name;
			_totalFinalProgress = totalFinalProgressPercent / 100;
		}

		public final function get name():String {
			return _name;
		}

		public final function get totalFinalProgress():Number {
			return _totalFinalProgress;
		}

		[Abstract]
		public function get percent():Number {
			throw new AbstractMethodException();
		}

		[Abstract]
		public function get completed():Boolean {
			throw new AbstractMethodException();
		}

		[Abstract]
		public function start():void {
			throw new AbstractMethodException();
		}

		[Abstract]
		public function finish():PreloaderPhase {
			throw new AbstractMethodException();
		}
	}
}
