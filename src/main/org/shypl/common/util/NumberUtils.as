package org.shypl.common.util {
	public final class NumberUtils {
		public static function formatNumber(value:Number, decimals:uint = 0, decimalSep:String = ".", thousandSep:String = " "):String {
			const notDecimals:Boolean = decimals == 0;

			if (isNaN(value)) {
				if (notDecimals) {
					return "0";
				}
				else {
					return "0" + decimalSep + StringUtils.repeat("0", decimals);
				}
			}

			const notThousands:Boolean = StringUtils.isEmpty(thousandSep);
			const numberString:String = value.toFixed(decimals);
			const numberPos:int = numberString.indexOf(".");

			var result:String = numberPos === -1 ? numberString : numberString.substr(0, numberPos);

			if (notThousands) {
				if (notDecimals) {
					return result;
				}
				return numberString;
			}

			const to:int = value < 0 ? 1 : 0;

			if (!notThousands) {
				for (var i:int = result.length - 3; i > to; i -= 3) {
					result = StringUtils.insert(result, thousandSep, i);
				}
			}

			if (notDecimals) {
				return result;
			}

			return result + decimalSep + numberString.substr(numberPos + 1);
		}

		public static function formatInt(value:int, thousandSep:String = " "):String {
			var to:int = value < 0 ? 1 : 0;
			var result:String = value.toString();
			for (var i:int = result.length - 3; i > to; i -= 3) {
				result = StringUtils.insert(result, thousandSep, i);
			}
			return result;
		}

		public static function formatUint(value:uint, thousandSep:String = " "):String {
			var result:String = value.toString();
			for (var i:int = result.length - 3; i > 0; i -= 3) {
				result = StringUtils.insert(result, thousandSep, i);
			}
			return result;
		}

		public static function defineWordDeclinationRu(number:Number, word1:String, word2:String, word5:String):String {
			if (number > 10 && number < 15) {
				return word5;
			}

			const str:String = number.toString();
			const last:int = parseInt(str.charAt(str.length - 1));

			if (last == 1) {
				return word1;
			}

			if (last != 0 && last < 5) {
				return word2;
			}

			return word5;
		}
	}
}
