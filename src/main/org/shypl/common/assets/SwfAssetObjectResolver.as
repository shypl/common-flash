package org.shypl.common.assets {
	public class SwfAssetObjectResolver {
		public static const DEFAULT:SwfAssetObjectResolver = new SwfAssetObjectResolver();

		public function getClassName(name:String, type:String):String {
			return name;
		}

		public function resolveObject(source:Object, type:String):Object {
			if (type == SwfAssetObjectType.TEXT_FIELD) {
				return source.label;
			}
			return source;
		}
	}
}
