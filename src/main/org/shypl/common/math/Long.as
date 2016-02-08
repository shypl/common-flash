package org.shypl.common.math {
	import org.shypl.common.util.Comparable;
	import org.shypl.common.util.StringUtils;

	public class Long implements Comparable {

		public static const MAX_VALUE:Long = new Long(new LongBits(0x7fffffff, 0xffffffff));
		public static const MIN_VALUE:Long = new Long(new LongBits(0x80000000, 0x00000000));

		public static const ZERO:Long = new Long(new LongBits(0x00000000, 0x00000000));
		public static const ONE:Long = new Long(new LongBits(0x00000000, 0x00000001));
		public static const NEGATIVE_ONE:Long = new Long(new LongBits(0xffffffff, 0xffffffff));

		private static const BASE_UINT:Number = Number(uint.MAX_VALUE) + Number(1);

		public static function valueOf(value:Object):Long {
			if (value is Long) {
				return value as Long;
			}
			if (value is String) {
				return valueOfString(value as String);
			}
			if (value is uint) {
				return valueOfUint(value as uint);
			}
			if (value is int) {
				return valueOfInt(value as int);
			}
			if (value is Number) {
				return valueOfNumber(value as Number);
			}

			throw new NumberFormatException("Cannot construct a Long from: " + value);
		}

		public static function valueOfString(value:String, radix:int = 10):Long {
			if (value === null || value.length === 0) {
				throw NumberFormatException.forInput("null");
			}

			const negative:Boolean = value.charAt(0) === "-";

			if (negative && value.length === 1) {
				throw NumberFormatException.forInput(value);
			}

			const bits:LongBits = LongBits.valueOfString(value, negative ? 1 : 0, radix);

			if (negative) {
				if (!(bits.high === 0x80000000 && bits.low === 0)) {
					if ((bits.high & 0x80000000) !== 0) {
						throw NumberFormatException.tooLarge(value);
					}
					if (bits.low === 0) {
						bits.high = 0x80000000 | ((~(bits.high)) + 1);
					}
					else {
						bits.low = (~(bits.low)) + 1;
						bits.high = 0x80000000 | (~(bits.high));
					}
				}
			}
			else if ((bits.high & 0x80000000) !== 0) {
				throw NumberFormatException.tooLarge(value);
			}

			return valueOfLongBits(bits);
		}

		public static function valueOfUnsignedString(value:String, radix:int = 10):Long {
			if (value === null || value.length === 0) {
				throw NumberFormatException.forInput("null");
			}
			return valueOfLongBits(LongBits.valueOfString(value, 0, radix));
		}

		public static function valueOfNumber(value:Number):Long {
			checkNumber(value);
			if (value === 0) {
				return ZERO;
			}
			if (value > 0 && value <= uint.MAX_VALUE) {
				return valueOfLongBits(new LongBits(0, value));
			}
			if (value < 0 && value >= int.MIN_VALUE) {
				return valueOfLongBits(new LongBits(0xffffffff, (~(-value)) + 1));
			}
			return valueOfString(value.toFixed(0));
		}

		public static function valueOfUint(value:uint):Long {
			if (value === 0) {
				return ZERO;
			}
			return valueOfLongBits(new LongBits(0, value));
		}

		public static function valueOfInt(value:int):Long {
			if (value === 0) {
				return ZERO;
			}
			if (value < 0) {
				return valueOfLongBits(new LongBits(0xffffffff, (~(-value)) + 1));
			}
			return valueOfLongBits(new LongBits(0, value));
		}

		public static function valueOfBits(high:uint, low:uint):Long {
			if (low === 0 && high === 0) {
				return ZERO;
			}
			if (low === 1 && high === 0) {
				return ONE;
			}
			if (low === NEGATIVE_ONE._bits.low && high === NEGATIVE_ONE._bits.high) {
				return NEGATIVE_ONE;
			}

			return new Long(new LongBits(high, low));
		}

		private static function valueOfLongBits(bits:LongBits):Long {
			if (bits.isZero()) {
				return ZERO;
			}
			if (bits.low === 1 && bits.high === 0) {
				return ONE;
			}
			if (bits.low === NEGATIVE_ONE._bits.low && bits.high === NEGATIVE_ONE._bits.high) {
				return NEGATIVE_ONE;
			}

			return new Long(bits);
		}

		private static function negateBits(bits:LongBits):void {
			bits.high = (bits.low === 0) ? ((~bits.high) + 1) : ~bits.high;
			bits.low = (~bits.low) + 1;
		}

		private static function checkNumber(value:Number):void {
			if (isNaN(value)) {
				throw new NumberFormatException("Illegal NaN parameter");
			}
			if (!isFinite(value)) {
				throw new NumberFormatException("Illegal infinite parameter");
			}
		}

		private var _bits:LongBits;

		public function Long(bits:LongBits) {
			_bits = bits;
		}

		public function get highBits():uint {
			return _bits.high;
		}

		public function get lowBits():uint {
			return _bits.low;
		}

		public function isZero():Boolean {
			return this === ZERO;
		}

		public function isOne():Boolean {
			return this === ONE;
		}

		public function isNegativeOne():Boolean {
			return this === NEGATIVE_ONE;
		}

		public function isNegative():Boolean {
			return sign() === -1;
		}

		public function compareTo(value:Object):int {
			const v:Long = valueOf(value);

			if (this === v) {
				return 0;
			}

			const sign:int = this.sign();
			const bSign:int = v.sign();

			if (sign === 0) {
				return -bSign;
			}

			if (sign === bSign) {
				if (_bits.high === v._bits.high) {
					if (_bits.low === v._bits.low) {
						return 0;
					}
					return _bits.low > v._bits.low ? 1 : -1;
				}
				return _bits.high > v._bits.high ? 1 : -1;
			}

			return sign < bSign ? -1 : 1;
		}

		public function compareUnsignedTo(value:Object):int {
			const v:Long = valueOf(value);

			if (this === v) {
				return 0;
			}

			if (_bits.high === v._bits.high) {
				if (_bits.low === v._bits.low) {
					return 0;
				}
				return _bits.low > v._bits.low ? 1 : -1;
			}

			return _bits.high > v._bits.high ? 1 : -1;
		}

		public function equals(value:Object):Boolean {
			return compareTo(value) === 0;
		}

		public function sign():int {
			if (isZero()) {
				return 0;
			}
			return (_bits.high & 0x80000000) === 0 ? 1 : -1;
		}

		public function abs():Long {
			if (sign() >= 0) {
				return this;
			}
			return negate();
		}

		public function negate():Long {
			if (isZero()) {
				return this;
			}
			const bits:LongBits = _bits.clone();
			negateBits(bits);
			return valueOfLongBits(bits);
		}

		public function not():Long {
			return valueOfBits(~_bits.high, ~_bits.low);
		}

		public function and(value:Object):Long {
			var v:Long = valueOf(value);
			return valueOfBits(_bits.high & v._bits.high, _bits.low & v._bits.low);
		}

		public function or(value:Object):Long {
			var v:Long = valueOf(value);
			return valueOfBits(_bits.high | v._bits.high, _bits.low | v._bits.low);
		}

		public function xor(value:Object):Long {
			var v:Long = valueOf(value);
			return valueOfBits(_bits.high ^ v._bits.high, _bits.low ^ v._bits.low);
		}

		public function shiftLeft(value:uint):Long {
			const bits:LongBits = _bits.clone();
			bits.shiftLeft(value);
			return valueOfLongBits(bits);
		}

		public function shiftRight(value:uint, unsigned:Boolean = false):Long {
			const bits:LongBits = _bits.clone();
			bits.shiftRight(value, unsigned);
			return valueOfLongBits(bits);
		}

		public function add(value:Object):Long {
			const v:Long = valueOf(value);

			if (v.isZero()) {
				return this;
			}

			const b:LongBits = new LongBits(_bits.high + v._bits.high, _bits.low + v._bits.low);

			if (b.low < _bits.low) {
				++b.high;
			}

			return valueOfLongBits(b);
		}

		public function subtract(value:Object):Long {
			const v:Long = valueOf(value);

			if (v.isZero()) {
				return this;
			}

			const b:LongBits = new LongBits(_bits.high - v._bits.high, _bits.low - v._bits.low);

			if (_bits.low < v._bits.low) {
				--b.high;
			}

			return valueOfLongBits(b);
		}

		public function multiply(value:Object):Long {
			var v:Long = valueOf(value);

			if (v.isZero()) {
				return ZERO;
			}
			if (v.isOne()) {
				return this;
			}
			if (v.isNegativeOne()) {
				return negate();
			}

			const b:LongBits = new LongBits();

			if (_bits.low === 1) {
				b.low = v._bits.low;
			}
			else if (_bits.low !== 0) {
				if (v._bits.low === 1) {
					b.low = _bits.low;
				}
				else if (v._bits.low !== 0) {
					LongBits.multiplyUintsTo(_bits.low, v._bits.low, b);
				}
			}

			b.high += (_bits.low * v._bits.high) + (v._bits.low * _bits.high);

			return valueOfLongBits(b);
		}

		public function divideAndRemainder(value:Object):LongDivideResult {
			const v:Long = valueOf(value);
			const vSign:int = v.sign();
			const sign:int = this.sign();

			if (vSign === 0) {
				throw new ArithmeticException("Cannot divide by zero");
			}

			if (sign === 0) {
				return new LongDivideResult(ZERO, ZERO);
			}

			if (v.isOne()) {
				return new LongDivideResult(this, ZERO);
			}
			if (v.isNegativeOne()) {
				return new LongDivideResult(negate(), ZERO);
			}

			const left:Long = sign < 0 ? this.negate() : this;
			const right:Long = vSign < 0 ? v.negate() : v;
			const comp:int = left.compareTo(right);

			if (comp < 0 && this !== MIN_VALUE) {
				return new LongDivideResult(ZERO, this);
			}

			if (comp === 0) {
				return new LongDivideResult(sign === vSign ? ONE : NEGATIVE_ONE, ZERO);
			}

			var b:LongBits;
			var q:Long;
			var r:Long;

			if (left._bits.high === 0) {
				q = valueOfBits(0, left._bits.low / right._bits.low);
				r = valueOfBits(0, left._bits.low % right._bits.low);
			}
			else if (right._bits.high === 0) {
				b = left._bits.clone();
				r = valueOfBits(0, b.divideByUint(right._bits.low));
				q = valueOfLongBits(b);
			}
			else {
				b = left._bits.clone();
				r = valueOfLongBits(b.divideByBits(right._bits));
				q = valueOfLongBits(b);
			}

			return new LongDivideResult(
				sign === vSign ? q : q.negate(),
				sign === -1 ? r.negate() : r
			);
		}

		public function divide(value:Object):Long {
			return divideAndRemainder(value).quotient;
		}

		public function remainder(value:Object):Long {
			return divideAndRemainder(value).remainder;
		}

		public function divideAndRemainderUnsigned(value:Object):LongDivideResult {
			const v:Long = valueOf(value);

			if (v.isZero()) {
				throw new ArithmeticException("Cannot divide by zero");
			}

			if (isZero()) {
				return new LongDivideResult(ZERO, ZERO);
			}

			if (v.isOne()) {
				return new LongDivideResult(this, ZERO);
			}

			const comp:int = compareUnsignedTo(v);

			if (comp < 0) {
				return new LongDivideResult(ZERO, this);
			}

			if (comp === 0) {
				return new LongDivideResult(ONE, ZERO);
			}

			var b:LongBits;
			var q:Long;
			var r:Long;

			if (_bits.high === 0) {
				q = valueOfBits(0, _bits.low / v._bits.low);
				r = valueOfBits(0, _bits.low % v._bits.low);
			}
			else if (v._bits.high === 0) {
				b = _bits.clone();
				r = valueOfBits(0, b.divideByUint(v._bits.low));
				q = valueOfLongBits(b);
			}
			else {
				b = _bits.clone();
				r = valueOfLongBits(b.divideByBits(v._bits));
				q = valueOfLongBits(b);
			}

			return new LongDivideResult(q, r);
		}

		public function divideUnsigned(value:Object):Long {
			return divideAndRemainderUnsigned(value).quotient;
		}

		public function remainderUnsigned(value:Object):Long {
			return divideAndRemainderUnsigned(value).remainder;
		}

		public function sqrt():Long {
			var p:Long = ONE;
			while (p.compareTo(this.divide(p)) <= 0) {
				p = p.shiftLeft(1);
			}
			var r:Long = valueOfLongBits(p._bits);

			do {
				p = r;
				r = r.add(this.divide(r)).shiftRight(1);
			}
			while (r.compareTo(p) < 0);

			return p;
		}

		public function sqrtUnsigned():Long {
			var p:Long = ONE;
			while (p.compareUnsignedTo(this.divideUnsigned(p)) <= 0) {
				p = p.shiftLeft(1);
			}
			var r:Long = valueOfLongBits(p._bits);

			do {
				p = r;
				r = r.add(this.divideUnsigned(r)).shiftRight(1, true);
			}
			while (r.compareUnsignedTo(p) < 0);

			return p;
		}

		public function intValue():int {
			return _bits.low;
		}

		public function numberValue():Number {
			var sign:int = this.sign();

			if (sign === 0) {
				return 0;
			}

			if (sign === 1) {
				return (Number(_bits.high) * BASE_UINT) + Number(_bits.low);
			}

			const abs:LongBits = _bits.clone();
			negateBits(abs);

			return Number(-1) * ((Number(abs.high) * BASE_UINT) + Number(abs.low));
		}

		public function toString(radix:int = 10):String {
			Radix.check(radix);

			if (_bits.high === 0) {
				return _bits.low.toString(radix);
			}

			if (isNegativeOne()) {
				return "-1";
			}

			if (radix === 10) {
				if (this === MAX_VALUE) {
					return "9223372036854775807";
				}
				if (this === MIN_VALUE) {
					return "-9223372036854775808";
				}
			}

			const neg:Boolean = isNegative();
			const bits:LongBits = _bits.clone();
			var str:String = "";

			if (neg) {
				negateBits(bits);
			}

			while (!bits.isZero()) {
				str = Radix.getCharForDigit(bits.divideByUint(radix)) + str;
			}

			if (neg) {
				str = "-" + str;
			}

			return str;
		}

		public function toUnsignedString(radix:int = 10):String {
			if (sign() >= 0) {
				return toString(radix);
			}

			Radix.check(radix);

			if (radix === 10 && this === NEGATIVE_ONE) {
				return "18446744073709551615";
			}

			const bits:LongBits = _bits.clone();
			var str:String = "";

			while (!bits.isZero()) {
				str = Radix.getCharForDigit(bits.divideByUint(radix)) + str;
			}

			return str;
		}

		public function format(thousandSep:String = " "):String {
			var to:int = isNegative() ? 1 : 0;
			var result:String = toString();
			for (var i:int = result.length - 3; i > to; i -= 3) {
				result = StringUtils.insert(result, thousandSep, i);
			}
			return result;
		}

		public function formatUnsigned(thousandSep:String = " "):String {
			var result:String = toUnsignedString();
			for (var i:int = result.length - 3; i > 0; i -= 3) {
				result = StringUtils.insert(result, thousandSep, i);
			}
			return result;
		}
	}
}
