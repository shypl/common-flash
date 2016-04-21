package org.shypl.common.assets {
	import flash.text.Font;
	import flash.text.FontStyle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import org.shypl.common.util.progress.Progress;

	public class FontAsset extends Asset {
		private var _font:Font;

		public function FontAsset(path:String) {
			super(path);
		}

		public function get font():Font {
			return _font;
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

		override protected function doLoad():Progress {
			return new FontAssetLoader(this);
		}

		override protected function doFree():void {
			_font = null;
		}

		internal function receiveData(font:Font):void {
			_font = font;
			completeLoad();
		}
	}
}
