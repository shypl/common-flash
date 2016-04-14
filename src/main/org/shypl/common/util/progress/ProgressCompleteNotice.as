package org.shypl.common.util.progress {
	import org.shypl.common.util.notice.Notice;

	public class ProgressCompleteNotice implements Notice {
		private var _progress:Progress;

		public function ProgressCompleteNotice(progress:Progress) {
			_progress = progress;
		}

		public function get progress():Progress {
			return _progress;
		}
	}
}
