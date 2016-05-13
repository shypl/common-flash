package org.shypl.common.util {
	import org.shypl.common.lang.IllegalStateException;

	internal class FilePathImpl implements FilePath {
		private var _parts:Vector.<String>;

		public function FilePathImpl(parts:Vector.<String>) {
			_parts = parts.concat();
		}

		public function get length():int {
			return _parts.length;
		}

		public function get parent():FilePath {
			checkEmpty();
			return factoryPath(_parts.slice(0, -1));
		}

		public function get fileName():String {
			return getPart(_parts.length - 1);
		}

		public function get parts():Vector.<String> {
			return _parts.concat();
		}

		public function isEmpty():Boolean {
			return _parts.length == 0;
		}

		public function getPart(index:int):String {
			checkEmpty();
			return _parts[index];
		}

		public function resolve(path:String):FilePath {
			return factoryPath(_parts.concat(FilePathUtils.splitToParts(path)));
		}

		public function resolvePath(path:FilePath):FilePath {
			return factoryPath(_parts.concat(path.parts));
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

		protected function factoryPath(parts:Vector.<String>):FilePath {
			return new FilePathImpl(parts);
		}

		protected function checkEmpty():void {
			if (isEmpty()) {
				throw new IllegalStateException("Path is empty");
			}
		}
	}
}
