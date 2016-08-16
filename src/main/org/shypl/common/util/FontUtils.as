package org.shypl.common.util {
	import flash.text.Font;
	import flash.text.FontStyle;
	
	public class FontUtils {
		public static function isEmbed(fontName:String, bold:Boolean = false, italic:Boolean = false):Boolean {
			for each (var font:Font in Font.enumerateFonts()) {
				if (font.fontName == fontName
					&& (bold ? (font.fontStyle == FontStyle.BOLD || font.fontStyle == FontStyle.BOLD_ITALIC) : true)
					&& (italic ? (font.fontStyle == FontStyle.ITALIC || font.fontStyle == FontStyle.BOLD_ITALIC) : true)
				) {
					return true;
				}
			}
			return false;
		}
	}
}
