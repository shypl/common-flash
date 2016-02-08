package org.shypl.common.assets {
	import flash.text.Font;
	import flash.text.FontStyle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import org.shypl.common.loader.FileLoader;
	import org.shypl.common.loader.FontReceiver;
	import org.shypl.common.util.Progress;

	public class FontAssetImpl extends AbstractAsset implements FontAsset, FontReceiver {
		private var _font:Font;

		public function FontAssetImpl(path:String, deferred:Boolean) {
			super(path, deferred);
		}

		public function get font():Font {
			return _font;
		}

		override public function load():Progress {
			return FileLoader.loadFont(path, this);
		}

		public function createTextFormat(size:uint = 12, color:uint = 0, align:String = TextFormatAlign.LEFT, leading:int = 0):TextFormat {
			return new TextFormat(
				_font.fontName,
				size,
				color,
				_font.fontStyle == FontStyle.BOLD || _font.fontStyle == FontStyle.BOLD_ITALIC,
				_font.fontStyle == FontStyle.ITALIC || _font.fontStyle == FontStyle.BOLD_ITALIC,
				null,
				null,
				null,
				align,
				null,
				null,
				null,
				leading
			);
		}

		public function setTextFormat(field:TextField, size:uint = 12, color:uint = 0, align:String = TextFormatAlign.LEFT, leading:int = 0):void {
			field.embedFonts = true;
			field.selectable = false;
			field.defaultTextFormat = createTextFormat(size, color, align, leading);
		}

		public function receiveFont(font:Font):void {
			_font = font;
			completeLoad()
		}

		override protected function doFree():void {
			_font = null;
		}
	}
}
