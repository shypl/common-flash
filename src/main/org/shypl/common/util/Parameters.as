package org.shypl.common.util {
	import org.shypl.common.lang.AbstractMethodException;

	[Abstract]
	public class Parameters {
		public function Parameters() {
		}

		[Abstract]
		public function contains(name:String):Boolean {
			throw new AbstractMethodException();
		}

		public function get(name:String, defaultValue:Object = null):Object {
			if (contains(name)) {
				return extract(name);
			}
			return defaultValue;
		}

		public function getBoolean(name:String, defaultValue:Boolean = false):Boolean {
			return Boolean(get(name, defaultValue));
		}

		public function getInt(name:String, defaultValue:int = 0):int {
			return int(get(name, defaultValue));
		}

		public function getUint(name:String, defaultValue:uint = 0):uint {
			return uint(get(name, defaultValue));
		}

		public function getNumber(name:String, defaultValue:uint = 0):Number {
			return Number(get(name, defaultValue));
		}

		public function getString(name:String, defaultValue:String = null):String {
			return get(name, defaultValue) as String;
		}

		[Abstract]
		protected function extract(name:String):Object {
			throw new AbstractMethodException();
		}
	}
}
