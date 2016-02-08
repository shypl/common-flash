package org.shypl.common.util {
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import org.shypl.common.lang.NullPointerException;

	public final class StringUtils {
		public static function isEmpty(string:String, ignoreWhitespace:Boolean = false):Boolean {
			if (string === null || string.length === 0) {
				return true;
			}

			if (ignoreWhitespace) {
				return isEmpty(trim(string));
			}

			return false;
		}

		public static function padLeft(string:String, pad:String, length:int):String {
			while (string.length < length) {
				string = pad + string;
			}
			return string;
		}

		public static function padRight(string:String, pad:String, length:int):String {
			while (string.length < length) {
				string += pad;
			}
			return string;
		}

		public static function trim(string:String, chars:String = " \t\r\n"):String {
			if (string === null) {
				throw new NullPointerException();
			}

			var s:int = 0;
			var e:int = string.length - 1;

			if (e === -1) {
				return "";
			}

			while (chars.indexOf(string.charAt(s)) !== -1) {
				++s;
			}

			while (chars.indexOf(string.charAt(e)) !== -1) {
				--e;
			}

			return e >= s ? string.slice(s, e + 1) : "";
		}

		public static function repeat(string:String, count:uint):String {
			if (isEmpty(string) || count === 0) {
				return "";
			}

			var result:String = "";
			while (count-- !== 0) {
				result += string;
			}
			return result;
		}

		public static function insert(string:String, insertion:String, position:uint, deleteChars:uint = 0):String {
			return string.substr(0, position) + insertion + string.substr(position + deleteChars);
		}

		public static function cut(string:String, from:uint, to:uint):String {
			return string.substr(0, from) + string.substr(to);
		}

		public static function startsWith(string:String, prefix:String):Boolean {
			return startsWith0(string, prefix, 0);
		}

		public static function endsWith(string:String, suffix:String):Boolean {
			return startsWith0(string, suffix, string.length - suffix.length);
		}

		public static function contains(string:String, part:String):Boolean {
			return string.indexOf(part) !== -1;
		}

		public static function toString(object:Object):String {
			if (object === null) {
				return "<null>";
			}

			if (CollectionUtils.isArrayOrVector(object)) {
				return toStringArrayOrVector(object);
			}

			if (object is Dictionary || object.constructor === Object) {
				return toStringDictionary(object);
			}

			if (object is Boolean) {
				return object ? "<true>" : "<false>";
			}

			if (object is ByteArray) {
				return "[" + HexUtils.encodeBytes(object as ByteArray, ", ") + "]";
			}

			return object.toString();
		}

		private static function toStringDictionary(map:Object):String {
			var string:String = "{";
			var sep:Boolean = false;
			for (var key:Object in map) {
				if (sep) {
					string += ", ";
				}
				else {
					sep = true;
				}
				string += toString(key) + ": " + toString(map[key]);
			}

			return string + "}";
		}

		private static function toStringArrayOrVector(array:Object):String {
			var length:uint = array.length;

			if (length === 0) {
				return "[]";
			}

			var string:String = "[";

			for (var i:uint = 0; i < length; ++i) {
				if (i !== 0) {
					string += ", ";
				}
				string += toString(array[i]);
			}

			string += "]";

			return string;
		}

		private static function startsWith0(string:String, prefix:String, offset:int):Boolean {
			var to:int = offset;
			var po:int = 0;
			var pc:int = prefix.length;

			if ((offset < 0) || (offset > string.length - pc)) {
				return false;
			}

			while (--pc >= 0) {
				if (string.charAt(to++) !== prefix.charAt(po++)) {
					return false;
				}
			}

			return true;
		}
	}
}
