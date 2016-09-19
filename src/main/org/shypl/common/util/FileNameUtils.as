package org.shypl.common.util {
	public final class FileNameUtils {

		public static const EXTENSION_SEPARATOR:String = '.';

		public static function getName(path:String):String {
			if (path == null) {
				return null;
			}
			var index:int = FilePathUtils.indexOfLastSeparator(path);
			return path.substring(index + 1);
		}

		public static function indexOfExtension(path:String):int {
			if (path == null) {
				return -1;
			}
			var extensionPos:int = path.lastIndexOf(EXTENSION_SEPARATOR);
			var lastSeparator:int = FilePathUtils.indexOfLastSeparator(path);
			return lastSeparator > extensionPos ? -1 : extensionPos;
		}

		public static function removeExtension(path:String):String {
			if (path == null) {
				return null;
			}
			var index:int = indexOfExtension(path);
			if (index == -1) {
				return path;
			}
			else {
				return path.substring(0, index);
			}
		}

		public static function getBaseName(path:String):String {
			return removeExtension(getName(path));
		}

		public static function getExtension(path:String):String {
			if (path == null) {
				return null;
			}
			var index:int = indexOfExtension(path);
			if (index == -1) {
				return "";
			}
			else {
				return path.substring(index + 1);
			}
		}

	}
}
