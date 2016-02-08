package org.shypl.common.math {
	import org.shypl.common.util.StringUtils;

	internal final class LongBits {
		public static function multiplyUints(a:uint, b:uint):LongBits {
			const bits:LongBits = new LongBits();
			multiplyUintsTo(a, b, bits);
			return bits;
		}

		public static function multiplyUintsTo(a:uint, b:uint, bits:LongBits):void {
			var a0:uint = a & 0xffff;
			var a1:uint = a >>> 16;
			var b0:uint = b & 0xffff;
			var b1:uint = b >>> 16;

			const a0b0:uint = a0 * b0;
			const a0b1:uint = a0 * b1;
			const a1b0:uint = a1 * b0;
			const a1b1:uint = a1 * b1;

			b0 = (a0b1 << 16);
			a0 = a0b0 + b0;
			if (a0 < a0b0 || a0 < b0) {
				a1 = 1;
			}
			else {
				a1 = 0;
			}

			b0 = (a1b0 << 16);
			b1 = a0 + b0;
			if (b1 < a0 || b1 < b0) {
				a1++;
			}

			bits.high = a1 + a1b1 + (a0b1 >>> 16) + (a1b0 >>> 16);
			bits.low = b1;
		}

		public static function valueOfString(string:String, offset:int, radix:int = 10):LongBits {
			Radix.check(radix);

			const bits:LongBits = new LongBits();

			if (radix > 10) {
				string = string.toLowerCase();
			}

			const len:int = string.length;
			var high:uint = 0;
			var digit:int;

			while (offset < len) {
				digit = Radix.getDigitForCharCode(string.charCodeAt(offset++), radix);
				if (digit === -1) {
					throw NumberFormatException.forInput(string);
				}
				bits.multiplyByUint0(radix);
				if (high > bits.high) {
					throw NumberFormatException.tooLarge(string);
				}
				bits.addUint0(digit);
				if (high > bits.high) {
					throw NumberFormatException.tooLarge(string);
				}
				high = bits.high;
			}

			return bits;
		}

		public var high:uint;
		public var low:uint;

		public function LongBits(high:uint = 0, low:uint = 0) {
			this.high = high;
			this.low = low;
		}

		public function clone():LongBits {
			return new LongBits(high, low);
		}

		public function getBinaryLength():int {
			if (isZero()) {
				return 1;
			}

			var n:int;
			var x:uint;

			if (high === 0) {
				n = 32;
				x = low;
			}
			else {
				n = 64;
				x = high;
			}

			if (x >> 16 === 0) {
				n -= 16;
				x <<= 16;
			}
			if (x >> 24 === 0) {
				n -= 8;
				x <<= 8;
			}
			if (x >> 28 === 0) {
				n -= 4;
				x <<= 4;
			}
			if (x >> 30 === 0) {
				n -= 2;
				x <<= 2;
			}
			n -= (x >> 31) + 1;
			return n;
		}

		public function isZero():Boolean {
			return low === 0 && high === 0;
		}

		public function isOne():Boolean {
			return low === 1 && high === 0;
		}

		public function compareToBits(value:LongBits):int {
			if (this === value) {
				return 0;
			}

			if (high > value.high) {
				return 1;
			}

			if (high < value.high) {
				return -1;
			}

			return low === value.low ? 0 : (low > value.low ? 1 : -1);
		}

		public function compareToUint(value:uint):int {
			if (high !== 0) {
				return 1;
			}

			return low === value ? 0 : (low > value ? 1 : -1);
		}

		public function shiftLeft(value:uint):void {
			value %= 64;

			if (value >= 32) {
				high = low << (value % 32);
				low = 0;
			}
			else if (value !== 0) {
				high = (high << value) | (low >>> (32 - value));
				low = low << value;
			}
		}

		public function shiftRight(value:uint, unsigned:Boolean = false):void {
			value %= 64;

			if (value >= 32) {
				if (unsigned) {
					low = high >>> (value % 32);
					high = 0;
				}
				else {
					low = high >> (value % 32);
					high = (high & 0x80000000) === 0 ? 0 : uint.MAX_VALUE;
				}
			}
			else if (value !== 0) {
				if (unsigned) {
					low = (low >>> value) | (high << (32 - value));
					high = high >>> value;
				}
				else {
					low = (low >> value) | (high << (32 - value));
					high = high >> value;
				}
			}
		}

		public function addUint(value:uint):void {
			if (value !== 0) {
				addUint0(value);
			}
		}

		public function subtractUint(value:uint):void {
			if (value !== 0) {
				if (low < value) {
					high--;
				}
				low -= value;
			}
		}

		public function subtractBits(value:LongBits):void {
			if (!value.isZero()) {
				high -= value.high;
				subtractUint(value.low);
			}
		}

		public function multiplyByUint(value:uint):void {
			if (value === 0) {
				low = 0;
				high = 0;
				return;
			}
			if (value === 1) {
				return;
			}
			if (high === 0 && low === 1) {
				low = value;
				return;
			}
			if (isZero()) {
				return;
			}

			multiplyByUint0(value);
		}

		public function divideByUint(value:uint):uint {
			if (value === 0) {
				throw new ArithmeticException("Cannot divide by 0");
			}

			if (isZero() || value === 1) {
				return 0;
			}

			if (high === 0) {
				if (low === value) {
					low = 1;
					return 0;
				}

				const r:uint = low % value;
				low /= value;
				return r;
			}

			if (high === value) {
				high = 1;

				if (low === value) {
					low = 1;
					return 0;
				}

				return divideByUint0(value);
			}

			return divideByUint1(value);
		}

		public function divideByBits(value:LongBits):LongBits {
			if (value.high === 0) {
				return new LongBits(0, divideByUint(value.low));
			}

			if (value.isZero()) {
				throw new ArithmeticException("Cannot divide by 0");
			}

			return divideByBits0(value);
		}

		public function toString():String {
			return "0x" + StringUtils.padLeft(high.toString(16), "0", 8) + StringUtils.padLeft(low.toString(16), "0", 8);
		}

		private function divideByUint0(value:uint):uint {
			// high > 0 && high === value && low !== value

			var r:uint;

			if (low < value) {
				r = low;
				low = 0;
			}
			else {
				const q:uint = low / value;
				r = low - (q * value);
				low = q;
			}

			return r;
		}

		private function divideByUint1(value:uint):uint {
			// high > 0 && high !== value

			const a:LongBits = clone();
			const b:LongBits = new LongBits(0, value);
			const q:LongBits = this;
			const vl:int = b.getBinaryLength();

			b.shiftLeft(a.getBinaryLength() - vl);

			q.high = 0;
			q.low = 0;

			while (a.compareToUint(value) >= 0) {
				if (a.compareToBits(b) >= 0) {
					var bl:int = b.getBinaryLength();

					a.subtractBits(b);
					q.shiftLeft(1);
					q.addUint0(1);
					b.shiftRight(1, true);

					if (a.compareToUint(value) === -1) {
						q.shiftLeft(bl - vl);
					}
				}
				else {
					q.shiftLeft(1);
					b.shiftRight(1, true);
				}
			}

			return a.low;
		}

		private function divideByBits0(value:LongBits):LongBits {
			const a:LongBits = clone();
			const b:LongBits = value.clone();
			const q:LongBits = this;
			const vl:int = b.getBinaryLength();

			b.shiftLeft(a.getBinaryLength() - vl);

			q.high = 0;
			q.low = 0;

			while (a.compareToBits(value) >= 0) {
				if (a.compareToBits(b) >= 0) {
					var bl:int = b.getBinaryLength();

					a.subtractBits(b);
					q.shiftLeft(1);
					q.addUint0(1);
					b.shiftRight(1, true);

					if (a.compareToBits(value) === -1) {
						q.shiftLeft(bl - vl);
					}
				}
				else {
					q.shiftLeft(1);
					b.shiftRight(1, true);
				}
			}

			return a;
		}

		private function addUint0(value:uint):void {
			low += value;
			if (low < value) {
				++high;
			}
		}

		private function multiplyByUint0(value:uint):void {
			var lb:uint = 0;
			var hb:uint = 0;

			if (low === 1) {
				lb = value;
			}
			else if (low !== 0) {
				const b:LongBits = multiplyUints(low, value);
				lb = b.low;
				hb = b.high;
			}

			hb += (value * high);

			low = lb;
			high = hb;
		}
	}
}
