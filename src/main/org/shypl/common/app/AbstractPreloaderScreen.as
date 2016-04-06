package org.shypl.common.app {
	import flash.display.Sprite;

	import org.shypl.common.lang.AbstractMethodException;

	[Abstract]
	public class AbstractPreloaderScreen extends Sprite {
		public function hide(completeCallback:Function):void {
			completeCallback();
		}

		public function resize(width:int, height:int):void {
		}

		[Abstract]
		public function updatePhaseName(name:String):void {
			throw new AbstractMethodException();
		}

		[Abstract]
		public function updateTotalProgress(percent:Number):void {
			throw new AbstractMethodException();
		}

		[Abstract]
		public function updatePhaseProgress(percent:Number):void {
			throw new AbstractMethodException();
		}
	}
}
