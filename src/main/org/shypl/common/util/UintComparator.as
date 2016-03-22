package org.shypl.common.util {
	public class UintComparator extends SimpleComparator {
		private static var LOW_TO_HIGH:UintComparator;
		private static var HIGH_TO_LOW:UintComparator;

		public static function getInstance(reverse:Boolean = false):Comparator {
			if (reverse) {
				if (HIGH_TO_LOW === null) {
					HIGH_TO_LOW = new UintComparator(true);
				}
				return HIGH_TO_LOW;
			}

			if (LOW_TO_HIGH === null) {
				LOW_TO_HIGH = new UintComparator(false);
			}

			return LOW_TO_HIGH;
		}

		public function UintComparator(reverse:Boolean) {
			super(reverse);
		}

		override protected function isGreater(a:Object, b:Object):Boolean {
			return uint(a) > uint(b);
		}
	}
}
