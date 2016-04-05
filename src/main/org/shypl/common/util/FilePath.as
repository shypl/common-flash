package org.shypl.common.util {
	import org.shypl.common.lang.IllegalStateException;

	import spark.primitives.Path;

	public class FilePath {
		public static function factory(path:String):FilePath {
			return new FilePath(FilePathUtils.splitToParts(path));
		}

		private var _parts:Vector.<String>;

		public function FilePath(parts:Vector.<String> = null) {
			_parts = parts == null ? new Vector.<String>(0, true) : parts;
		}

		public function get length():int {
			return _parts.length;
		}

		public function get parent():FilePath {
			checkEmpty();
			return createPath(_parts.slice(0, -2));
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
