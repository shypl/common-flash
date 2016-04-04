package org.shypl.common.util.progress {
	import org.shypl.common.util.CollectionUtils;

	public class UnevenCompositeProgress extends CompositeProgress {
		public static function factoryEmpty(divisions:Vector.<int>):CompositeProgress {
			var progresses:Vector.<Progress> =
				CollectionUtils.createVectorAndFill(Vector.<Progress>, divisions.length, new NotCompletedProgress()) as Vector.<Progress>;

			return new UnevenCompositeProgress(progresses, divisions);
		}

		private var _divisions:Vector.<Number>;

		public function UnevenCompositeProgress(progresses:Vector.<Progress>, divisions:Vector.<int>) {
			super(progresses);

			var divisionsSum:int = CollectionUtils.sum(divisions);

			_divisions = new Vector.<Number>(divisions.length, true);
			for (var i:int = 0; i < divisions.length; i++) {
				_divisions[i] = divisions[i] / divisionsSum;
			}
		}

		override public function get percent():Number {
			var total:Number = 0;

			for (var i:int = 0; i < _progresses.length; i++) {
				total += _progresses[i].percent * _divisions[i];
			}

			return total;
		}
	}
}
