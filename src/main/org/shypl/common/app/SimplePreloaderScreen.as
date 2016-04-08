package org.shypl.common.app {
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	import org.shypl.common.timeline.GlobalTimeline;

	public class SimplePreloaderScreen extends AbstractPreloaderScreen {
		private var _box:Sprite;
		private var _progressBar:Shape;
		private var _progressBarLabel:TextField;

		public function SimplePreloaderScreen() {
			_box = new Sprite();
			addChild(_box);
			createTextField(_box, 200, 0, "Loading", 14, TextFieldAutoSize.CENTER);

			_progressBar = createProgressBar(_box, _box.height + 10, 15);
			_progressBarLabel = createTextField(_box, 410, _progressBar.y - 2);
		}

		override public function resize(width:int, height:int):void {
			super.resize(width, height);

			graphics.clear();
			graphics.beginFill(0);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();

			_box.x = int((width - 400) / 2);
			_box.y = int((height - _box.height) / 2);
		}

		override public function update(progressPercent:Number):void {
			updateProgressBar(_progressBar, _progressBarLabel, progressPercent);
		}

		override public function hide(completeCallback:Function):void {
			GlobalTimeline.schedule(500, completeCallback);
		}

		private function updateProgressBar(bar:Shape, label:TextField, percent:Number):void {
			var height:int = bar.height;
			bar.graphics.clear();
			bar.graphics.beginFill(0x333333);
			bar.graphics.drawRect(0, 0, 400, height);
			bar.graphics.endFill();
			bar.graphics.beginFill(0xffffff);
			bar.graphics.drawRect(0, 0, int(400 * percent), height);
			bar.graphics.endFill();

			label.text = int(percent * 100) + "%";
		}

		private function createProgressBar(container:DisplayObjectContainer, y:int, height:int):Shape {
			var bar:Shape = new Shape();
			bar.graphics.beginFill(0x333333);
			bar.graphics.drawRect(0, 0, 400, height);
			bar.graphics.endFill();
			bar.y = y;

			container.addChild(bar);

			return bar;
		}

		private function createTextField(container:DisplayObjectContainer, x:int, y:int, text:String = "", fontSize:int = 12,
			autoSize:String = TextFieldAutoSize.LEFT
		):TextField {
			var field:TextField = new TextField();
			field.defaultTextFormat = new TextFormat("Verdana", fontSize, 0xFFFFFF);
			field.selectable = false;
			field.autoSize = autoSize;
			field.x = x;
			field.y = y;
			field.text = text;

			container.addChild(field);

			return field;
		}
	}
}