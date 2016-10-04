package org.shypl.common.util.numerator {
	import org.shypl.common.math.Long;
	import org.shypl.common.timeline.Timeline;
	
	public class LongNumerator extends Numerator {
		public function LongNumerator(handler:NumeratorHandler, sourceValue:Long, timeline:Timeline = null) {
			super(handler, sourceValue, timeline);
		}
		
		public final function get sourceValueLong():Long {
			return sourceValue as Long;
		}
		
		public final function get currentValueLong():Long {
			return currentValue as Long;
		}
		
		public final function get targetValueLong():Long {
			return targetValue as Long;
		}
		
		public final function get stepValueLong():Long {
			return stepValue as Long;
		}
		
		public final function get stepDiffValueLong():Long {
			return stepDiffValue as Long;
		}
		
		override protected function getZeroValue():Object {
			return 0;
		}
		
		override protected function sum(a:Object, b:Object):Object {
			return (a as Long).add(b);
		}
		
		override protected function subtract(a:Object, b:Object):Object {
			return (a as Long).subtract(b);
		}
		
		override protected function compare(a:Object, b:Object):int {
			return (a as Long).compareTo(b);
		}
		
		override protected function calculateStepValue():Object {
			var diff:Long = stepDiffValueLong;
			var e:int = 0;
			
			while (diff.compareTo(10) == 1) {
				diff = diff.divide(10);
				++e;
			}
			
			var s:Long = Long.ONE;
			while (e > 0) {
				s = s.multiply(10);
				--e;
			}
			
			return s;
		}
	}
}
