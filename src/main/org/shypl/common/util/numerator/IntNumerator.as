package org.shypl.common.util.numerator {
	import org.shypl.common.timeline.Timeline;

	public class IntNumerator extends Numerator {
		public static const DEFAULT_STEPS_DEFINER:Function = function (diff:int):int {
			return Math.round(Math.sqrt(diff)) / 2
		};

		public function IntNumerator(handler:Function, value:Object, stepsDefiner:Function = null, timeline:Timeline = null) {
			super(handler, value, stepsDefiner !== null ? stepsDefiner : DEFAULT_STEPS_DEFINER, timeline);
		}

		override protected function compare(a:Object, b:Object):int {
			return a === b ? 0 : (a > b ? 1 : -1);
		}

		override protected function add(a:Object, b:Object):Object {
			return a + b;
		}

		override protected function subtract(a:Object, b:Object):Object {
			return int(a) - int(b);
		}

		override protected function defineStepSize(diff:Object, steps:int):Object {
			return int(diff) / steps;
		}
	}
}
