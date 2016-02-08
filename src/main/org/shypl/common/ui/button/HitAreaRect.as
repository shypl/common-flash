package org.shypl.common.ui.button {
	import flash.display.Sprite;

	public class HitAreaRect extends Sprite {
		public function HitAreaRect(width:Number, height:Number, corner:Number = 0, x:Number = 0, y:Number = 0) {
			graphics.beginFill(0xff00ff);
			if (corner == 0) {
				graphics.drawRect(x, y, width, height);
			}
			else {
				graphics.drawRoundRect(x, y, width, height, corner);
			}
			graphics.endFill();
		}
	}
}
