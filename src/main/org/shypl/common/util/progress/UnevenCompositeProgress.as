package org.shypl.common.util.progress {
	import org.shypl.common.util.CollectionUtils;

	public class UnevenCompositeProgress extends CompositeProgress {
		public static function factoryEmpty(divisions:Vector.<int>):CompositeProgress {
			return new UnevenCompositeProgress(
				CollectionUtils.createVectorAndFill(Progress, divisions.length, FakeProgress.NOT_COMPLETED) as Vector.<Progress>,
				divisions
			);
		}

		private var _divisions:Vector.<Number>;

		public function UnevenCompositeProgress(progresses:Vector.<Progress>, divisions:Vector.<int>) {
			super(progresses);
			if (!completed) {
				var divisionsSum:int = CollectionUtils.sum(divisions);

				_divisions = new Vector.<Number>(divisions.length, true);
				for (var i:int = 0; i < divisions.length; i++) {
					_divisions[i] = divisions[i] / divisionsSum;
				}
			}
		}

		override protected function calculatePercent():Number {
			var total:Number = 0;
			for (var i:int = 0; i < _children.length; i++) {
				total += _children[i].percent * _divisions[i];
			}
			return total;
		}
	}
}
