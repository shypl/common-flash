package org.shypl.common.util.progress {
	import org.shypl.common.util.CollectionUtils;

	public class UnevenCompositeProgress extends CompositeProgress {
		public static function factoryEmpty(divisions:Vector.<int>):CompositeProgress {
			var progresses:Vector.<Progress> = CollectionUtils.createVectorAndFill(Progress, divisions.length, NotCompletedProgress.INSTANCE) as
				Vector.<Progress>;

			return new UnevenCompositeProgress(progresses, divisions);
		}

		private var _divisions:Vector.<Number>;

		public function UnevenCompositeProgress(progresses:Vector.<Progress>, divisions:Vector.<int>) {
			super(progresses);
			if (progresses.length > 0) {
				var divisionsSum:int = CollectionUtils.sum(divisions);

				_divisions = new Vector.<Number>(divisions.length, true);
				for (var i:int = 0; i < divisions.length; i++) {
					_divisions[i] = divisions[i] / divisionsSum;
				}
			}
		}

		override public function get percent():Number {
			if (_progresses.length == 0) {
				return 1;
			}
			
			var total:Number = 0;

			for (var i:int = 0; i < _progresses.length; i++) {
				total += _progresses[i].percent * _divisions[i];
			}

			return total;
		}
	}
}
