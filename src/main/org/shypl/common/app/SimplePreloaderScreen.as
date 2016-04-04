package org.shypl.common.app {
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class SimplePreloaderScreen extends AbstractPreloaderScreen {
		private var _box:Sprite;
		private var _totalProgressBar:Shape;
		private var _phaseProgressBar:Shape;
		private var _totalProgressBarLabel:TextField;
		private var _phaseProgressBarLabel:TextField;
		private var _phaseLabel:TextField;

		public function SimplePreloaderScreen() {
			_box = new Sprite();
			addChild(_box);
			createTextField(_box, 200, 0, "Loading", 14, TextFieldAutoSize.CENTER);

			_totalProgressBar = createProgressBar(_box, _box.height + 10, 15);
			_phaseProgressBar = createProgressBar(_box, _totalProgressBar.y + _totalProgressBar.height + 10, 5);

			_totalProgressBarLabel = createTextField(_box, 410, _totalProgressBar.y - 2);
			_phaseProgressBarLabel = createTextField(_box, 410, _phaseProgressBar.y - 4, "", 9);

			_phaseLabel = createTextField(_box, 200, _phaseProgressBar.y + _phaseProgressBar.height + 10, "", 10, TextFieldAutoSize.CENTER);
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

		override public function updatePhaseName(name:String):void {
			_phaseLabel.text = name;
		}

		override public function updateTotalProgress(percent:Number):void {
			updateProgressBar(_totalProgressBar, _totalProgressBarLabel, percent);
		}

		override public function updatePhaseProgress(percent:Number):void {
			updateProgressBar(_phaseProgressBar, _phaseProgressBarLabel, percent);
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