package org.shypl.common.app {
	import org.shypl.common.assets.AssetsCollector;
	import org.shypl.common.util.progress.CompositeProgress;
	import org.shypl.common.util.progress.Progress;

	public class ModularSystem {
		private var _list:Vector.<Module> = new Vector.<Module>();
		private var _facades:ModuleFacadesImpl = new ModuleFacadesImpl();

		public function ModularSystem(modules:Vector.<Module> = null) {
			if (modules != null) {
				addMany(modules);
			}
		}

		public function add(module:Module):void {
			_facades.add(module);
			_list.push(module);
		}

		public function addMany(modules:Vector.<Module>):void {
			for each (var module:Module in modules) {
				add(module);
			}
		}

		public function prepareAssets(assets:AssetsCollector):void {
			for each (var module:Module in _list) {
				module.prepareAssets(assets);
			}
		}

		public function start():Progress {
			var progresses:Vector.<Progress> = new Vector.<Progress>(_list.length);
			for (var i:int = 0; i < _list.length; i++) {
				progresses[i] = _list[i].start(_facades);
			}

			_list.length = 0;
			_list = null;

			_facades = null;

			return new CompositeProgress(progresses);
		}
	}
}
