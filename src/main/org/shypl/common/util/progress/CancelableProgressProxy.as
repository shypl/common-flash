package org.shypl.common.util.progress {
	public class CancelableProgressProxy extends ProgressProxy implements CancelableProgress {
		public function CancelableProgressProxy(source:CancelableProgress = null) {
			super(source);
		}
		
		override public function setProgress(value:Progress):void {
			super.setProgress(CancelableProgress(value));
		}
		
		public function cancel():void {
			CancelableProgress(getProgress()).cancel();
		}
	}
}
