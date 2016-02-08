package org.shypl.common.util {
	import org.shypl.common.lang.IllegalStateException;

	public class SimplePath implements Path {
		private var _path:String;

		public function SimplePath(path:String = null) {
			if (path === "") {
				path = null;
			}
			else if (path !== null) {
				while (StringUtils.endsWith(path, "/")) {
					path = path.substr(0, -1);
				}
			}
			_path = path;
		}

		public function get parent():Path {
			if (_path === null) {
				throw new IllegalStateException();
			}

			var i:int = _path.lastIndexOf("/");
			if (i === -1) {
				throw new IllegalStateException();
			}
			return new SimplePath(_path.substring(0, i));
		}

		public function get isEmpty():Boolean {
			return _path === null;
		}

		protected function get path():String {
			return _path;
		}

		public function resolve(path:String):Path {
			var i:int;
			var p:Path = this;
			while ((i = path.indexOf("../")) >= 0) {
				p = p.parent;
				path = path.substr(3);
			}
			return new SimplePath(p.isEmpty ? path : (p.toString() + "/" + path));
		}

		public function resolveSibling(path:String):Path {
			return parent.resolve(path);
		}

		public function toString():String {
			return _path;
		}
	}
}
