package org.shypl.common.util.numerator {
	import org.shypl.common.timeline.Timeline;
	
	public class NumberNumerator extends Numerator {
		public function NumberNumerator(handler:NumeratorHandler, sourceValue:int, timeline:Timeline = null) {
			super(handler, sourceValue, timeline);
		}
		
		public final function get sourceValueNumber():Number {
			return sourceValue as Number;
		}
		
		public final function get currentValueNumber():Number {
			return currentValue as Number;
		}
		
		public final function get targetValueNumber():Number {
			return targetValue as Number;
		}
		
		public final function get stepValueNumber():Number {
			return stepValue as Number;
		}
		
		public final function get stepDiffValueNumber():Number {
			return stepDiffValue as Number;
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
		
		override protected function calculateStepValue():Object {
			var diff:int = stepDiffValueNumber;
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
			
			return s;
		}
	}
}
