package org.shypl.common.util {
	public class ObjectParameters extends Parameters {
		private var _obj:Object;

		public function ObjectParameters(obj:Object) {
			_obj = obj;
		}

		override public function contains(name:String):Boolean {
			return name in _obj;
		}

		[Abstract]
		override protected function extract(name:String):Object {
			return _obj[name];
		}
	}
}
