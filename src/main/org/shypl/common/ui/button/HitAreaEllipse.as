package org.shypl.common.ui.button {
	import flash.display.Sprite;

	public class HitAreaEllipse extends Sprite {
		public function HitAreaEllipse(width:Number, height:Number = 0, x:Number = 0, y:Number = 0) {
			graphics.beginFill(0xff00ff);
			if (height == 0) {
				graphics.drawCircle(x, y, width / 2);
			}
			else {
				graphics.drawEllipse(x, y, width, height);
			}
			graphics.endFill();
		}
	}
}
