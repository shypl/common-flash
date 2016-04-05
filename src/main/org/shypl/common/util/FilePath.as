package org.shypl.common.util {
	import org.shypl.common.lang.IllegalStateException;

	public class FilePath {
		public static function splitToParts(path:String):Vector.<String> {
			if (StringUtils.isEmpty(path)) {
				return new Vector.<String>(0, true);
			}

			path = StringUtils.trim(path, "/");

			var vector:Vector.<String> = Vector.<String>(path.split("/"));
			vector.fixed = true;
			return vector;
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

		public function isEmpty():Boolean {
			return _parts.length == 0;
		}

		public function getPartName(index:int):String {
			checkEmpty();
			return _parts[index];
		}

		public function resolve(path:String):FilePath {
			return createPath(_parts.concat(splitToParts(path)));
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
			return isEmpty() ? "" : _parts.join("/");
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
