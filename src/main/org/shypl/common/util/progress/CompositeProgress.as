package org.shypl.common.util.progress {
	import org.shypl.common.util.CollectionUtils;

	public class CompositeProgress implements Progress {
		public static function factoryEmpty(size:int):CompositeProgress {
			return new CompositeProgress(
				CollectionUtils.createVectorAndFill(Vector.<Progress>, size, new NotCompletedProgress()) as Vector.<Progress>
			);
		}

		protected var _progresses:Vector.<Progress>;

		public function CompositeProgress(progresses:Vector.<Progress>) {
			_progresses = progresses.concat();
			_progresses.fixed = true;
		}

		public function get completed():Boolean {
			for each (var progress:Progress in _progresses) {
				if (!progress.completed) {
					return false;
				}
			}
			return true;
		}

		public function get percent():Number {
			var total:Number = 0;

			for each (var progress:Progress in _progresses) {
				total += progress.percent;
			}

			return total / _progresses.length;
		}

		public function setProgressAt(index:int, progress:Progress):void {
			_progresses[index] = progress;
		}
	}
}
