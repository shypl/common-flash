package org.shypl.common.ui {
	import flash.display.Graphics;
	import flash.display.Shape;

	import org.shypl.common.util.DestroyableSprite;
	import org.shypl.common.timeline.GlobalTimeline;
	import org.shypl.common.timeline.TimelineTask;

	public class LoadingIcon extends DestroyableSprite {
		private var _icon:Shape;
		private var _step:Number;
		private var _updateTask:TimelineTask;

		public function LoadingIcon(color:uint = 0, alpha:Number = 1,
			backgroundColor:int = -1, backgroundAlpha:Number = 1, backgroundWidth:uint = 0, backgroundHeight:uint = 0
		) {
			const w:uint = 30;
			const n:uint = 8;
			const r:uint = 3;

			_icon = new Shape();

			const s:Number = (360 * Math.PI / 180) / n;
			const sa:Number = alpha / n;
			const wr:Number = (w / 2) - r;
			var g:Graphics = _icon.graphics;

			for (var i:int = 0; i < n; ++i) {
				var a:Number = s * i;
				g.beginFill(color, sa * i);
				g.drawCircle(Math.cos(a) * wr, Math.sin(a) * wr, r);
				g.endFill();
			}

			if (backgroundColor >= 0) {
				g = graphics;
				g.beginFill(backgroundColor, backgroundAlpha);
				g.drawRect(0, 0,
					backgroundWidth > 0 ? backgroundWidth : w,
					backgroundHeight > 0 ? backgroundHeight : w);
				g.endFill();
			}

			_icon.x = (width) / 2;
			_icon.y = (height) / 2;

			addChild(_icon);

			_step = 360 / n;

			_updateTask = GlobalTimeline.scheduleRepeatable(50, update);
		}

		override protected function doDestroy():void {
			_updateTask.cancel();
			_updateTask = null;
			_icon.graphics.clear();
			_icon = null;
		}

		private function update():void {
			_icon.rotation += _step;
		}
	}
}
