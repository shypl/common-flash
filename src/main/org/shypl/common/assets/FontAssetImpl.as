package org.shypl.common.assets {
	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	import flash.text.Font;
	import flash.text.FontStyle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import org.shypl.common.lang.RuntimeException;
	import org.shypl.common.loader.FileLoader;
	import org.shypl.common.loader.SwfReceiver;
	import org.shypl.common.util.progress.Progress;

	internal class FontAssetImpl extends AbstractAsset implements FontAsset, SwfReceiver {
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

		private var _font:Font;
		private var _domain:ApplicationDomain;

		public function FontAssetImpl(name:String, path:String, deferred:Boolean) {
			super(name, path, deferred);
		}

		public function get font():Font {
			return _font;
		}

		override public function load():Progress {
			_domain = new ApplicationDomain(ApplicationDomain.currentDomain);
			return FileLoader.loadSwf(path, this, _domain);
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

		public function receiveSwf(sprite:Sprite):void {
			var fontClass:Class = Class(_domain.getDefinition("ExternalFont"));
			_font = getFont(fontClass);

			if (_font == null) {
				Font.registerFont(fontClass);
				_font = getFont(fontClass);
			}

			if (_font == null) {
				throw new RuntimeException("Can't initialize font asset " + name + "(" + fontClass + ")");
			}

			completeLoad()
		}

		override protected function doFree():void {
			_font = null;
		}
	}
}
