package org.shypl.common.util {
	public class FilePathProxy implements FilePath {
		private var _source:FilePath;

		public function FilePathProxy(source:FilePath) {
			_source = source;
		}

		public function get length():int {
			return _source.length;
		}

		public function get parent():FilePath {
			return _source.parent;
		}

		public function get fileName():String {
			return _source.fileName;
		}

		public function get parts():Vector.<String> {
			return _source.parts;
		}

		public function isEmpty():Boolean {
			return _source.isEmpty();
		}

		public function getPart(index:int):String {
			return _source.getPart(index);
		}

		public function resolve(path:String):FilePath {
			return _source.resolve(path);
		}

		public function resolvePath(path:FilePath):FilePath {
			return _source.resolvePath(path);
		}

		public function resolveSibling(path:String):FilePath {
			return _source.resolveSibling(path);
		}

		public function resolveSiblingPath(path:FilePath):FilePath {
			return _source.resolveSiblingPath(path);
		}

		public function toString():String {
			return _source.toString();
		}

		public function toUnixString():String {
			return _source.toUnixString();
		}

		public function toWindowsString():String {
			return _source.toWindowsString();
		}
	}
}
