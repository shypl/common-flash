package org.shypl.common.timeline {
	import org.shypl.common.lang.UnsupportedOperationException;
	
	internal final class GlobalTimelineImpl extends Timeline {
		override public function stop():void {
			throw new UnsupportedOperationException("Unable to stop global timeline")
		}
		
		override public function pause():void {
			throw new UnsupportedOperationException("Unable to pause global timeline")
		}
		
		override public function resume():void {
			throw new UnsupportedOperationException("Unable to resume global timeline")
		}
		
		override protected function checkStopped():void {
		}
	}
}
