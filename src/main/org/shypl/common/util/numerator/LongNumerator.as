package org.shypl.common.util.numerator {
	import org.shypl.common.math.Long;
	import org.shypl.common.timeline.Timeline;
	
	public class LongNumerator extends Numerator {
		/*public static const DEFAULT_STEPS_DEFINER:Function = function (diff:Long):int {
			return diff.sqrt().intValue() / 2;
		};

		public function LongNumerator(handler:Function, value:Long, stepsDefiner:Function = null, timeline:Timeline = null) {
			super(handler, value, stepsDefiner !== null ? stepsDefiner : DEFAULT_STEPS_DEFINER, timeline);
		}

		override protected function compare(a:Object, b:Object):int {
			return Long(a).compareTo(b);
		}

		override protected function add(a:Object, b:Object):Object {
			return Long(a).add(b);
		}

		override protected function subtract(a:Object, b:Object):Object {
			return Long(a).subtract(b);
		}

		override protected function defineStepSize(diff:Object, steps:int):Object {
			var v:Long = Long(diff).divide(steps);
			return (v.isZero() || v.isNegative()) ? Long.ONE : v;
		}*/
		
		public function LongNumerator(handler:NumeratorHandler, sourceValue:Long, timeline:Timeline = null) {
			super(handler, sourceValue, timeline);
		}
		
		public final function get sourceLong():Long {
			return sourceValue as Long;
		}
		
		public final function get currentLong():Long {
			return currentValue as Long;
		}
		
		public final function get targetLong():Long {
			return targetValue as Long;
		}
		
		public final function get stepLong():Long {
			return stepValue as Long;
		}
		
		override protected function getZeroValue():Object {
			return 0;
		}
		
		override protected function sum(a:Object, b:Object):Object {
			return (a as Long).add(b);
		}
		
		override protected function compare(a:Object, b:Object):int {
			return (a as Long).compareTo(b);
		}
		
		override protected function calculateStep(time:int):Object {
			var diff:Long = isIncrease() ? targetLong.subtract(currentValue) : currentLong.subtract(targetValue);
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
			
			return isIncrease() ? s : s.negate();
		}
	}
}
