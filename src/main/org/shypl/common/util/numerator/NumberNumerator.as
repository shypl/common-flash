package org.shypl.common.util.numerator {
	import org.shypl.common.timeline.Timeline;
	
	public class NumberNumerator extends Numerator {
		public function NumberNumerator(handler:NumeratorHandler, sourceValue:int, timeline:Timeline = null) {
			super(handler, sourceValue, timeline);
		}
		
		public final function get sourceNumber():Number {
			return sourceValue as Number;
		}
		
		public final function get currentNumber():Number {
			return currentValue as Number;
		}
		
		public final function get targetNumber():Number {
			return targetValue as Number;
		}
		
		public final function get stepNumber():Number {
			return stepValue as Number;
		}
		
		override protected function getZeroValue():Object {
			return 0;
		}
		
		override protected function sum(a:Object, b:Object):Object {
			return (a as Number) + (b as Number);
		}
		
		override protected function compare(a:Object, b:Object):int {
			return a == b ? 0 : (a > b ? 1 : -1);
		}
		
		override protected function calculateStep(time:int):Object {
			var diff:int = isIncrease() ? (targetNumber - currentNumber) : (currentNumber - targetNumber);
			var e:int = 0;
			
			while (diff > 10) {
				diff /= 10;
				++e;
			}
			
			var s:int = 1;
			while (e > 0) {
				s *= 10;
				--e;
			}
			
			return isIncrease() ? s : -s;
		}
	}
}
