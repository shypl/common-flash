package org.shypl.common.util.progress {
	import org.shypl.common.util.CollectionUtils;

	public class CompositeProgress extends AbstractProgress {
		public static function factoryEmpty(size:int):CompositeProgress {
			return new CompositeProgress(
				CollectionUtils.createVectorAndFill(Progress, size, FakeProgress.NOT_COMPLETED) as Vector.<Progress>
			);
		}

		protected var _children:Vector.<Progress>;

		public function CompositeProgress(children:Vector.<Progress>) {
			_children = children.concat();
			_children.fixed = true;
			if (_children.length == 0) {
				complete();
			}
			else {
				var completedCount:int = 0;
				for each (var progress:Progress in _children) {
					if (progress.completed) {
						++completedCount;
					}
					else {
						progress.addNoticeHandler(ProgressCompleteNotice, onChildComplete, false);
					}
				}
				if (completedCount == _children.length) {
					complete();
				}
			}
		}

		public function setChild(index:int, progress:Progress):void {
			_children[index].removeNoticeHandler(ProgressCompleteNotice, onChildComplete);
			_children[index] = progress;
			if (progress.completed) {
				onChildComplete();
			}
			else {
				_children[index].addNoticeHandler(ProgressCompleteNotice, onChildComplete, false);
			}
		}

		public function getChild(index:int):Progress {
			return _children[index];
		}

		override protected function calculatePercent():Number {
			var total:Number = 0;
			for each (var progress:Progress in _children) {
				total += progress.percent;
			}
			return total / _children.length;
		}

		protected final function isAllChildrenCompleted():Boolean {
			for each (var progress:Progress in _children) {
				if (!progress.completed) {
					return false;
				}
			}
			return true;
		}

		protected function onChildComplete():void {
			if (isAllChildrenCompleted()) {
				complete();
			}
		}

		override protected function complete():void {
			for each (var progress:Progress in _children) {
				progress.removeNoticeHandler(ProgressCompleteNotice, onChildComplete);
			}
			_children = null;
			super.complete();
		}
	}
}
