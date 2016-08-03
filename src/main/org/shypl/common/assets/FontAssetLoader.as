package org.shypl.common.assets {
	import flash.system.ApplicationDomain;
	import flash.text.Font;
	
	import org.shypl.common.lang.RuntimeException;
	import org.shypl.common.loader.FileLoader;
	import org.shypl.common.loader.SwfFile;
	import org.shypl.common.loader.SwfReceiver;
	import org.shypl.common.util.progress.ProgressProxy;
	
	internal class FontAssetLoader extends ProgressProxy implements SwfReceiver {
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
		
		private var _asset:FontAsset;
		
		public function FontAssetLoader(asset:FontAsset) {
			_asset = asset;
			setProgress(FileLoader.loadSwf(_asset.path.toString(), this, new ApplicationDomain(ApplicationDomain.currentDomain)));
		}
		
		public function receiveSwf(swf:SwfFile):void {
			var fontClass:Class = Class(swf.domain.getDefinition("ExternalFont"));
			var font:Font = getFont(fontClass);
			
			if (font == null) {
				Font.registerFont(fontClass);
				font = getFont(fontClass);
			}
			
			if (font == null) {
				throw new RuntimeException("Can't initialize font asset " + _asset.path + "(" + fontClass + ")");
			}
			
			_asset.receiveData(font);
			_asset = null;
		}
	}
}
