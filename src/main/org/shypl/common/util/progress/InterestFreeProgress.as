package org.shypl.common.util.progress {
	public class InterestFreeProgress extends AbstractProgress {
		override protected function calculatePercent():Number {
			return 0;
		}
	}
}
