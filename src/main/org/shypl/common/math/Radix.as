package org.shypl.common.math {
	import org.shypl.common.lang.IllegalArgumentException;

	public final class Radix {
		public static const MIN_VALUE:int = 2;
		public static const MAX_VALUE:int = 36;

		private static const DIGIT_TO_CHAR:Vector.<String> = new <String>[
			"0", "1", "2", "3", "4", "5",
			"6", "7", "8", "9", "a", "b",
			"c", "d", "e", "f", "g", "h",
			"i", "j", "k", "l", "m", "n",
			"o", "p", "q", "r", "s", "t",
			"u", "v", "w", "x", "y", "z"
		];

		private static const CHAR_CODE_TO_DIGIT:Vector.<int> = (function ():Vector.<int> {
			var map:Vector.<int> = new Vector.<int>(DIGIT_TO_CHAR[DIGIT_TO_CHAR.length - 1].charCodeAt() + 1, true);
			var i:int = 0;

			for (; i < map.length; ++i) {
				map[i] = -1;
			}

			for (i = 0; i < DIGIT_TO_CHAR.length; ++i) {
				map[DIGIT_TO_CHAR[i].charCodeAt()] = i;
			}

			return map;
		})();

		{
			DIGIT_TO_CHAR.fixed = true;
		}

		public static function check(radix:int):void {
			if (radix < Radix.MIN_VALUE) {
				throw new IllegalArgumentException("Radix " + radix + " less than Radix.MIN");
			}
			if (radix > Radix.MAX_VALUE) {
				throw new IllegalArgumentException("Radix " + radix + " greater than Radix.MAX");
			}
		}

		public static function getCharForDigit(digit:int):String {
			return DIGIT_TO_CHAR[digit];
		}

		public static function getDigitForChar(char:String, radix:int):int {
			return getDigitForCharCode(char.charCodeAt(), radix);
		}

		public static function getDigitForCharCode(code:int, radix:int):int {
			if (code < 0) {
				return -1;
			}
			const digit:int = CHAR_CODE_TO_DIGIT[code];
			return digit >= radix ? -1 : digit;
		}
	}
}