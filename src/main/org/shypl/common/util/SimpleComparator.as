package org.shypl.common.util {
	public class SimpleComparator implements Comparator {

		private static var LOW_TO_HIGH:SimpleComparator;
		private static var HIGH_TO_LOW:SimpleComparator;

		public static function getInstance(reverse:Boolean = false):Comparator {
			if (reverse) {
				if (HIGH_TO_LOW === null) {
					HIGH_TO_LOW = new SimpleComparator(true);
				}
				return HIGH_TO_LOW;
			}

			if (LOW_TO_HIGH === null) {
				LOW_TO_HIGH = new SimpleComparator(false);
			}

			return LOW_TO_HIGH;
		}

		private var _reverse:Boolean;

		public function SimpleComparator(reverse:Boolean) {
			_reverse = reverse;
		}

		public function compare(a:Object, b:Object):int {
			if (a === b) {
				return 0;
			}
			if (isGreater(a, b)) {
				return _reverse ? -1 : 1;
			}
			return _reverse ? 1 : -1;
		}

		protected function isGreater(a:Object, b:Object):Boolean {
			return a > b;
		}
	}
}




