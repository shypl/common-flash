package org.shypl.common.app {
	import org.shypl.common.assets.AssetsCollector;
	import org.shypl.common.lang.AbstractMethodException;
	import org.shypl.common.util.progress.CompletedProgress;
	import org.shypl.common.util.progress.Progress;

	[Abstract]
	public class Module {
		private var _facadeClass:Class;

		public function Module(facadeClass:Class) {
			_facadeClass = facadeClass;
		}

		[Abstract]
		public function getFacade():Object {
			throw new AbstractMethodException();
		}

		public function prepareAssets(assets:AssetsCollector):void {
		}

		public function start(modules:ModuleFacades):Progress {
			return CompletedProgress.INSTANCE;
		}

		internal function getFacadeClass():Class {
			return _facadeClass;
		}
	}
}
