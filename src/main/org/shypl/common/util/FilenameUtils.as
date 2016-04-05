package org.shypl.common.util {
	public final class FilenameUtils {

		public static const EXTENSION_SEPARATOR:String = '.';

		private static const UNIX_SEPARATOR:String = "/";

		private static const WINDOWS_SEPARATOR:String = "\\";

		public static function getName(filename:String):String {
			if (filename == null) {
				return null;
			}
			var index:int = indexOfLastSeparator(filename);
			return filename.substring(index + 1);
		}

		public static function indexOfLastSeparator(filename:String):int {
			if (filename == null) {
				return -1;
			}
			var lastUnixPos:int = filename.lastIndexOf(UNIX_SEPARATOR);
			var lastWindowsPos:int = filename.lastIndexOf(WINDOWS_SEPARATOR);
			return Math.max(lastUnixPos, lastWindowsPos);
		}

		public static function indexOfExtension(filename:String):int {
			if (filename == null) {
				return -1;
			}
			var extensionPos:int = filename.lastIndexOf(EXTENSION_SEPARATOR);
			var lastSeparator:int = indexOfLastSeparator(filename);
			return lastSeparator > extensionPos ? -1 : extensionPos;
		}

		public static function removeExtension(filename:String):String {
			if (filename == null) {
				return null;
			}
			var index:int = indexOfExtension(filename);
			if (index == -1) {
				return filename;
			}
			else {
				return filename.substring(0, index);
			}
		}

		public static function getBaseName(filename:String):String {
			return removeExtension(getName(filename));
		}

		public static function getExtension(filename:String):String {
			if (filename == null) {
				return null;
			}
			var index:int = indexOfExtension(filename);
			if (index == -1) {
				return "";
			}
			else {
				return filename.substring(index + 1);
			}
		}

	}
}
