package org.shypl.common.util.numerator {
	import org.shypl.common.math.Long;
	import org.shypl.common.timeline.Timeline;

	public class LongNumerator extends Numerator {
		public static const DEFAULT_STEPS_DEFINER:Function = function (diff:Long):int {
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
		}
	}
}
