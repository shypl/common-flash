package org.shypl.common.assets {
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public interface FontAsset extends Asset {
		function get font():Font;

		function createTextFormat(size:uint = 12, color:uint = 0, align:String = TextFormatAlign.LEFT, leading:int = 0):TextFormat;
	}
}
