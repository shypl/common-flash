package org.shypl.common.util {
	public final class FilePaths {
		public static function get(path:String):FilePath {
			return new FilePathImpl(FilePathUtils.splitToParts(path));
		}
	}
}
