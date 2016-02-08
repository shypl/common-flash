package org.shypl.common.timeline {
	import org.shypl.common.lang.UnsupportedOperationException;

	internal final class GlobalTimelineImpl extends Timeline {
		override protected function doStop():void {
			throw new UnsupportedOperationException("Unable to stop global timeline")
		}

		override protected function doPause():void {
			throw new UnsupportedOperationException("Unable to pause global timeline")
		}

		override protected function doResume():void {
			throw new UnsupportedOperationException("Unable to resume global timeline")
		}

		override internal function checkStopped():void {
		}
	}
}
