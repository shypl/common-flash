package org.shypl.common.lang {
	import flash.utils.getQualifiedClassName;

	public class Enum {
		public static function valueOfName(enumType:Class, name:String):Enum {
			const value:Enum = EnumRegistry.getRegistry(enumType).getByName(name)
			if (value === null) {
				throw new IllegalArgumentException("No enum value " + getQualifiedClassName(enumType) + "." + name);
			}
			return value;
		}

		public static function valueOfOrdinal(enumType:Class, ordinal:int):Enum {
			const value:Enum = EnumRegistry.getRegistry(enumType).getByOrdinal(ordinal);
			if (value === null) {
				throw new IllegalArgumentException("No enum value " + getQualifiedClassName(enumType) + " of ordinal " + ordinal);
			}
			return value;
		}

		public static function values(enumType:Class):Vector.<Enum> {
			return EnumRegistry.getRegistry(enumType).getValues();
		}

		private var _name:String;
		private var _ordinal:int;

		public function Enum(name:String) {
			_name = name;
			_ordinal = EnumRegistry.add(this);

			if (_ordinal === -1) {
				throw new IllegalArgumentException("Value " + name + " is already defined in enum " + getQualifiedClassName(this));
			}
		}

		public final function get name():String {
			return _name;
		}

		public final function get ordinal():int {
			return _ordinal;
		}

		public final function toString():String {
			return _name;
		}
	}
}






