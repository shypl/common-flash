package org.shypl.common.util {
	import flash.text.Font;
	import flash.text.FontStyle;
	
	public class FontUtils {
		private static const EMBED_CACHE:Object = {};
		private static const EMBED_CACHE_MASK_FONT:int = 1;
		private static const EMBED_CACHE_MASK_REGULAR:int = 2;
		private static const EMBED_CACHE_MASK_BOLD:int = 4;
		private static const EMBED_CACHE_MASK_ITALIC:int = 8;
		private static const EMBED_CACHE_MASK_BOLD_ITALIC:int = 16;
		
		public static function isEmbed(fontName:String, bold:Boolean = false, italic:Boolean = false):Boolean {
			var mask:int = EMBED_CACHE[fontName];
			if (mask === 0) {
				mask = EMBED_CACHE_MASK_FONT;
				for each (var font:Font in Font.enumerateFonts()) {
					if (font.fontName == fontName) {
						switch (font.fontStyle) {
							case FontStyle.REGULAR:
								mask |= EMBED_CACHE_MASK_REGULAR;
								break;
							case FontStyle.BOLD:
								mask |= EMBED_CACHE_MASK_BOLD;
								break;
							case FontStyle.ITALIC:
								mask |= EMBED_CACHE_MASK_ITALIC;
								break;
							case FontStyle.BOLD_ITALIC:
								mask |= EMBED_CACHE_MASK_BOLD_ITALIC;
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
				return (mask & EMBED_CACHE_MASK_BOLD_ITALIC) !== 0;
			}
			
			if (bold) {
				return (mask & EMBED_CACHE_MASK_BOLD) !== 0;
			}
			
			if (italic) {
				return (mask & EMBED_CACHE_MASK_ITALIC) !== 0;
			}
			
			return (mask & EMBED_CACHE_MASK_REGULAR) !== 0;
		}
	}
}
