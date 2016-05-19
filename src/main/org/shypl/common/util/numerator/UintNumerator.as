package org.shypl.common.util.numerator {
	import org.shypl.common.math.Long;
	import org.shypl.common.timeline.Timeline;

	public class UintNumerator extends Numerator {
		public static const DEFAULT_STEPS_DEFINER:Function = function (diff:uint):int {
			return Math.round(Math.sqrt(diff)) / 2
		};

		public function UintNumerator(handler:Function, value:Long, stepsDefiner:Function = null, timeline:Timeline = null) {
			super(handler, value, stepsDefiner !== null ? stepsDefiner : DEFAULT_STEPS_DEFINER, timeline);
		}

		override protected function compare(a:Object, b:Object):int {
			return a === b ? 0 : (a > b ? 1 : -1);
		}

		override protected function add(a:Object, b:Object):Object {
			return a + b;
		}

		override protected function subtract(a:Object, b:Object):Object {
			return uint(a) - uint(b);
		}

		override protected function defineStepSize(diff:Object, steps:int):Object {
			var v:uint = uint(uint(diff) / steps);
			return v == 0 ? 1 : v;
		}
	}
}
