package org.shypl.common.loader {
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	import flash.text.Font;

	import org.shypl.common.lang.RuntimeException;

	internal class FontLoader extends SwfLoader implements SwfReceiver {
		private static function getFont(fontClass:Class):Font {
			var fonts:Array = Font.enumerateFonts();
			for (var i:uint = 0, l:uint = fonts.length; i < l; ++i) {
				var font:Font = fonts[i];
				if (font is fontClass) {
					return font;
				}
			}
			return null;
		}

		private var _receiver:FontReceiver;

		public function FontLoader(url:String, receiver:FontReceiver) {
			super(url, this, new ApplicationDomain(ApplicationDomain.currentDomain));
			_receiver = receiver;
		}

		public function receiveSwf(sprite:Sprite):void {
			var fontClass:Class = Class(domain.getDefinition("ExternalFont"));
			var font:Font = getFont(fontClass);

			if (font == null) {
				Font.registerFont(fontClass);
				font = getFont(fontClass);
			}

			if (font == null) {
				throw new RuntimeException();
			}

			_receiver.receiveFont(font);
			_receiver = null;
		}
	}
}
