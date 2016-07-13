package org.shypl.common.util.progress {
	public class UnevenCompositeProgressBuilder {
		protected var _progresses:Vector.<Progress> = new Vector.<Progress>();
		protected var _divisions:Vector.<int> = new Vector.<int>();
		
		public function UnevenCompositeProgressBuilder() {
		}
		
		public function add(progress:Progress, division:int):UnevenCompositeProgressBuilder {
			_progresses.push(progress);
			_divisions.push(division);
			return this;
		}
		
		public function build():UnevenCompositeProgress {
			return new UnevenCompositeProgress(_progresses, _divisions);
		}
	}
}
