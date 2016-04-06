package org.shypl.common.util {
	public final class FilePathUtils {
		public static const UNIX_SEPARATOR:String = "/";
		public static const WINDOWS_SEPARATOR:String = "\\";

		private static const SEPARATORS:String = UNIX_SEPARATOR + WINDOWS_SEPARATOR;

		public static function splitToParts(path:String):Vector.<String> {
			if (StringUtils.isEmpty(path)) {
				return new Vector.<String>(0, true);
			}

			path = StringUtils.trim(path, SEPARATORS);

			var vector:Vector.<String>;

			if (isUnixPath(path)) {
				vector = Vector.<String>(path.split(UNIX_SEPARATOR));
			}
			else {
				vector = Vector.<String>(path.split(WINDOWS_SEPARATOR));
			}
			vector.fixed = true;
			return vector;
		}

		public static function isUnixPath(path:String):Boolean {
			return path.indexOf(UNIX_SEPARATOR) !== -1;
		}

		public static function isWindowsPath(path:String):Boolean {
			return path.indexOf(WINDOWS_SEPARATOR) !== -1;
		}

		public static function joinToUnix(parts:Vector.<String>):String {
			return parts.join(UNIX_SEPARATOR);
		}

		public static function joinToWindows(parts:Vector.<String>):String {
			return parts.join(WINDOWS_SEPARATOR);
		}

		public static function indexOfLastSeparator(path:String):int {
			if (path == null) {
				return -1;
			}

			var index:int = path.lastIndexOf(UNIX_SEPARATOR);

			if (index === -1) {
				return path.lastIndexOf(WINDOWS_SEPARATOR);
			}

			return index;
		}

		public static function parent(path:String):String {
			var index:int = path.lastIndexOf(UNIX_SEPARATOR);

			if (index === -1) {
				index = path.lastIndexOf(WINDOWS_SEPARATOR);
			}

			if (index === -1) {
				return "";
			}

			return path.substring(0, index);
		}

		public static function resolveSibling(path:String, sibling:String):String {
			var index:int = path.lastIndexOf(UNIX_SEPARATOR);

			if (index === -1) {
				index = path.lastIndexOf(WINDOWS_SEPARATOR);
			}

			if (index === -1) {
				return sibling;
			}

			return path.substring(0, index + 1) + sibling;
		}
	}
}
