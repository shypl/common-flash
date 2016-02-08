package org.shypl.common.lang {
	import flash.utils.getQualifiedClassName;

	internal final class EnumRegistry {
		private static const _registries:Object = {};

		public static function add(enum:Enum):int {
			const name:String = getQualifiedClassName(enum);
			var registry:EnumRegistry = _registries[name];
			if (registry === null) {
				registry = new EnumRegistry();
				_registries[name] = registry;
			}
			return registry.register(enum);
		}

		public static function getRegistry(type:Class):EnumRegistry {
			const name:String = getQualifiedClassName(type);
			const registry:EnumRegistry = _registries[name];
			if (registry === null) {
				throw new IllegalArgumentException(name + " is not an enum type");
			}
			return registry;
		}

		///

		private var _list:Vector.<Enum> = new Vector.<Enum>();
		private var _map:Object = {};

		public function EnumRegistry() {
		}

		public function getByName(name:String):Enum {
			return _map[name];
		}

		public function getByOrdinal(ordinal:int):Enum {
			return ordinal >= _list.length ? null : _list[ordinal];
		}

		public function getValues():Vector.<Enum> {
			var enums:Vector.<Enum> = _list.concat();
			enums.fixed = true;
			return enums;
		}

		private function register(enum:Enum):int {
			if (enum.name in _map) {
				return -1;
			}
			_map[enum.name] = enum;
			return _list.push(enum) - 1;
		}
	}
}
