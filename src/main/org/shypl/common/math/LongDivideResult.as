package org.shypl.common.math {
	public class LongDivideResult {
		private var _quotient:Long;
		private var _remainder:Long;

		public function LongDivideResult(quotient:Long, remainder:Long) {
			_quotient = quotient;
			_remainder = remainder;
		}

		public function get quotient():Long {
			return _quotient;
		}

		public function get remainder():Long {
			return _remainder;
		}
	}
}
