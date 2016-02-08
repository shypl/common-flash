package org.shypl.common.util {
	import flash.utils.ByteArray;

	public final class HexUtils {
		private static const DIGITS:Vector.<String> = new <String>["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"];

		public static function encodeByte(b:int):String {
			b = b & 0xFF;
			return DIGITS[b >>> 4] + DIGITS[b & 0x0F];
		}

		public static function encodeBytes(bytes:ByteArray, separator:String = ""):String {
			var p:int = bytes.position;
			bytes.position = 0;

			var len:int = bytes.bytesAvailable;
			var string:Vector.<String> = new Vector.<String>(len, true);
			for (var i:int = 0; i < len; ++i) {
				string[i] = encodeByte(bytes.readByte());
			}

			bytes.position = p;
			return string.join(separator);
		}
	}
}
