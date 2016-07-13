package org.shypl.common.util.progress {
	import flash.utils.getTimer;
	
	import org.shypl.common.timeline.GlobalTimeline;
	import org.shypl.common.util.Cancelable;
	
	public class TemporaryProgress extends AbstractProgress {
		private var _totalTime:int;
		private var _autoComplete:Boolean;
		private var _autoCompleteTask:Cancelable;
		private var _lostTime:int;
		private var _startTime:int = -1;
		
		public function TemporaryProgress(seconds:int, autoComplete:Boolean, autoStartPlay:Boolean = true) {
			_totalTime = seconds * 1000;
			_lostTime = _totalTime;
			_autoComplete = autoComplete;
			
			if (autoStartPlay) {
				startPlay();
			}
		}
		
		private function get played():Boolean {
			return _startTime !== -1;
		}
		
		public final function makeComplete():void {
			complete();
		}
		
		public final function startPlay():void {
			if (!played) {
				_startTime = getTimer();
				if (_autoComplete) {
					_autoCompleteTask = GlobalTimeline.schedule(_lostTime, complete);
				}
			}
		}
		
		public final function stopPlay():void {
			if (played) {
				cancelAutoCompleteTask();
				_lostTime = _totalTime - (getTimer() - _startTime);
				_startTime = -1;
			}
		}
		
		public function cancelAutoCompleteTask():void {
			if (_autoComplete) {
				_autoCompleteTask.cancel();
				_autoCompleteTask = null;
			}
		}
		
		override protected function calculatePercent():Number {
			var passedTime:int = played ? (getTimer() - _startTime) : _totalTime - _lostTime;
			if (passedTime >= _totalTime) {
				return _autoComplete ? 1 : 0.99;
			}
			return passedTime / _totalTime * (_autoComplete ? 1 : 0.99);
		}
		
		override protected function complete():void {
			cancelAutoCompleteTask();
			super.complete();
		}
	}
}
