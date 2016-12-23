package org.shypl.common.util {
	import flash.text.Font;
	import flash.text.FontStyle;
	
	public class FontUtils {
		private static const EMBED_CACHE:Object = {};
		private static const EMBED_CACHE_EXISTS:int = 1;
		private static const EMBED_CACHE_REGULAR:int = 2;
		private static const EMBED_CACHE_BOLD:int = 4;
		private static const EMBED_CACHE_ITALIC:int = 8;
		private static const EMBED_CACHE_BOLD_ITALIC:int = 16;
		
		public static function isEmbed(fontName:String, bold:Boolean = false, italic:Boolean = false):Boolean {
			var mask:int = EMBED_CACHE[fontName];
			if (mask === 0) {
				mask = EMBED_CACHE_EXISTS;
				for each (var font:Font in Font.enumerateFonts()) {
					if (font.fontName == fontName) {
						switch (font.fontStyle) {
							case FontStyle.REGULAR:
								mask |= EMBED_CACHE_REGULAR;
								break;
							case FontStyle.BOLD:
								mask |= EMBED_CACHE_BOLD;
								break;
							case FontStyle.ITALIC:
								mask |= EMBED_CACHE_ITALIC;
								break;
							case FontStyle.BOLD_ITALIC:
								mask |= EMBED_CACHE_BOLD_ITALIC;
								break;
						}
					}
				}
				EMBED_CACHE[fontName] = mask;
			}
			
			if (mask === 0) {
				return false;
			}
			
			if (bold && italic) {
				return (mask & EMBED_CACHE_BOLD_ITALIC) !== 0;
			}
			
			if (bold) {
				return (mask & EMBED_CACHE_BOLD) !== 0;
			}
			
			if (italic) {
				return (mask & EMBED_CACHE_ITALIC) !== 0;
			}
			
			return (mask & EMBED_CACHE_REGULAR) !== 0;
		}
		
		public static function hasFont(name:String, bold:Boolean = false, italic:Boolean = false):Boolean {
			return getFont(name, bold, italic) !== null;
		}
		
		public static function getFont(name:String, bold:Boolean = false, italic:Boolean = false):Font {
			var font:Font = findFont(false, name, bold, italic);
			if (font === null) {
				font = findFont(true, name, bold, italic);
			}
			return font;
		}
		
		private static function findFont(device:Boolean, name:String, bold:Boolean = false, italic:Boolean = false):Font {
			var neededMask:int = (bold ? 1 : 0) | (italic ? 2 : 0);
			var mask:int;
			
			for each (var font:Font in Font.enumerateFonts(device)) {
				if (font.fontName == name) {
					switch (font.fontStyle) {
						case FontStyle.REGULAR:
							mask = 0;
							break;
						case FontStyle.BOLD:
							mask = 1;
							break;
						case FontStyle.ITALIC:
							mask = 2;
							break;
						case FontStyle.BOLD_ITALIC:
							mask = 1 | 2;
							break;
					}
					if (mask == neededMask) {
						return font;
					}
				}
			}
			
			return null;
		}
	}
}
