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
		public function update(progressPercent:Number):void {
			throw new AbstractMethodException();
		}
	}
}
