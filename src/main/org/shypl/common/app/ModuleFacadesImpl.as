package org.shypl.common.app {
	import flash.utils.Dictionary;

	internal class ModuleFacadesImpl implements ModuleFacades {


		private var _map:Dictionary = new Dictionary();

		public function ModuleFacadesImpl() {
		}

		public function get(type:Class):* {
			return Module(_map[type]).getFacade();
		}

		internal function add(module:Module):void {
			_map[module.getFacadeClass()] = module;
		}
	}
}