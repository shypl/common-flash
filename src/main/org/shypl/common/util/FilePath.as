package org.shypl.common.util {
	import org.shypl.common.lang.IllegalStateException;

	public class FilePath {
		public static function factory(path:String, base:String = null):FilePath {
			return new FilePath(FilePathUtils.splitToParts(path), base);
		}

		private var _parts:Vector.<String>;

		public function FilePath(parts:Vector.<String> = null, base:String = null) {
			_parts = parts == null ? new Vector.<String>(0) : parts.concat();
			if (base !== null) {
				if (StringUtils.endsWith(base, FilePathUtils.UNIX_SEPARATOR)) {
					base = StringUtils.trimRight(base, FilePathUtils.UNIX_SEPARATOR);
				}
				else if (StringUtils.endsWith(base, FilePathUtils.WINDOWS_SEPARATOR)) {
					base = StringUtils.trimRight(base, FilePathUtils.WINDOWS_SEPARATOR);
				}
				_parts.unshift(base);
			}
		}

		public function get length():int {
			return _parts.length;
		}

		public function get parent():FilePath {
			checkEmpty();
			return createPath(_parts.slice(0, -1));
		}

		public function get fileName():String {
			return getPartName(_parts.length - 1);
		}

		public function get parts():Vector.<String> {
			return _parts.concat();
		}

		public function isEmpty():Boolean {
			return _parts.length == 0;
		}

		public function getPartName(index:int):String {
			checkEmpty();
			return _parts[index];
		}

		public function resolve(path:String):FilePath {
			return createPath(_parts.concat(FilePathUtils.splitToParts(path)));
		}

		public function resolvePath(path:FilePath):FilePath {
			return createPath(_parts.concat(path._parts));
		}

		public function resolveSibling(path:String):FilePath {
			return parent.resolve(path);
		}

		public function resolveSiblingPath(path:FilePath):FilePath {
			return parent.resolvePath(path);
		}

		public function toString():String {
			return toUnixString();
		}

		public function toUnixString():String {
			return FilePathUtils.joinToUnix(_parts);
		}

		public function toWindowsString():String {
			return FilePathUtils.joinToWindows(_parts);
		}

		protected function createPath(parts:Vector.<String>):FilePath {
			return new FilePath(parts);
		}

		protected function checkEmpty():void {
			if (isEmpty()) {
				throw new IllegalStateException("Path is empty");
			}
		}
	}
}
