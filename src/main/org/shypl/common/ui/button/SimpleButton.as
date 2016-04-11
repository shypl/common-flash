package org.shypl.common.ui.button {
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class SimpleButton extends Button {
		public static const TEXT_FORMAT:TextFormat = new TextFormat();
		{
			TEXT_FORMAT.font = "Verdana";
			TEXT_FORMAT.size = 12;
		}

		private var _label:TextField;

		public function SimpleButton(label:String = "") {
			_label = new TextField();
			_label.defaultTextFormat = TEXT_FORMAT;
			_label.autoSize = TextFieldAutoSize.LEFT;
			_label.selectable = false;
			_label.text = label;

			_label.x = 7;
			_label.y = 5;

			addChild(_label);
		}

		public function get label():String {
			return _label.text;
		}

		public function set label(text:String):void {
			_label.text = text;
			update();
		}

		override protected function update():void {
			graphics.clear();

			switch (buttonState) {
				case ButtonState.NORMAL:
					graphics.beginFill(0x6699cc);
					break;
				case ButtonState.HOVER:
					graphics.beginFill(0x3399cc);
					break;
				case ButtonState.ACTIVE:
					graphics.beginFill(0x0099ff);
					break;
				case ButtonState.DISABLED:
					graphics.beginFill(0xcccccc);
					break;
			}

			graphics.drawRect(0, 0, 14 + _label.width, 10 + _label.height);
			graphics.endFill();
		}
	}
}
