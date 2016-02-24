package org.shypl.common.util {
	import org.shypl.common.lang.IllegalStateException;

	public class SimplePath implements Path {
		private var _value:String;

		public function SimplePath(value:String = null) {
			if (value === "") {
				value = null;
			}
			else if (value !== null) {
				while (StringUtils.endsWith(value, "/")) {
					value = value.substr(0, -1);
				}
			}
			_value = value;
		}

		public function get empty():Boolean {
			return _value === null;
		}

		public function get parent():Path {
			if (_value === null) {
				throw new IllegalStateException();
			}

			var i:int = _value.lastIndexOf("/");
			if (i === -1) {
				throw new IllegalStateException();
			}

			return factoryPath(_value.substring(0, i));
		}

		public function get value():String {
			return _value;
		}

		public function resolve(path:String):Path {
			var i:int;
			var p:Path = this;
			while ((i = path.indexOf("..")) == 0) {
				p = p.parent;
				if (path.indexOf("../") == 0) {
					path = path.substr(3);
				}
				else {
					path = path.substr(2);
				}
			}
			return factoryPath(p.empty ? path : (p.value + "/" + path));
		}

		public function resolveSibling(path:String):Path {
			return parent.resolve(path);
		}

		public function toString():String {
			return _value;
		}

		protected function factoryPath(value:String):Path {
			return new SimplePath(value);
		}
	}
}
