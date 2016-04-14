package org.shypl.common.util.progress {
	import org.shypl.common.util.CollectionUtils;
	import org.shypl.common.util.notice.NoticeDispatcher;

	public class CompositeProgress extends NoticeDispatcher implements Progress {
		public static function factoryEmpty(size:int):CompositeProgress {
			return new CompositeProgress(
				CollectionUtils.createVectorAndFill(Progress, size, NotCompletedProgress.INSTANCE) as Vector.<Progress>
			);
		}

		protected var _children:Vector.<Progress>;

		public function CompositeProgress(children:Vector.<Progress>) {
			_children = children.concat();
			_children.fixed = true;
			for each (var progress:Progress in _children) {
				progress.addNoticeHandler(ProgressCompleteNotice, onChildComplete);
			}
		}

		public function get completed():Boolean {
			for each (var progress:Progress in _children) {
				if (!progress.completed) {
					return false;
				}
			}
			return true;
		}

		public function get percent():Number {
			if (_children.length == 0) {
				return 1;
			}

			var total:Number = 0;

			for each (var progress:Progress in _children) {
				total += progress.percent;
			}

			return total / _children.length;
		}

		public function setChild(index:int, progress:Progress):void {
			_children[index].removeNoticeHandler(ProgressCompleteNotice, onChildComplete);
			_children[index] = progress;
			if (progress.completed) {
				onChildComplete();
			}
			else {
				_children[index].addNoticeHandler(ProgressCompleteNotice, onChildComplete);
			}
		}

		public function getChild(index:int):Progress {
			return _children[index];
		}

		protected function onChildComplete():void {
			if (completed) {
				for each (var progress:Progress in _children) {
					progress.removeNoticeHandler(ProgressCompleteNotice, onChildComplete);
				}
				dispatchNotice(new ProgressCompleteNotice(this));
				removeAllNoticeHandlers();
			}
		}
	}
}
