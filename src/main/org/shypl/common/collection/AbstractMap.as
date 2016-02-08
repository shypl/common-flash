package org.shypl.common.collection {
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	import org.shypl.common.lang.AbstractMethodException;
	import org.shypl.common.lang.RuntimeException;
	import org.shypl.common.lang.UnsupportedOperationException;
	import org.shypl.common.util.StringUtils;

	[Abstract]
	public class AbstractMap extends Proxy implements Map {
		public function get length():int {
			return size();
		}

		[Abstract]
		public function size():int {
			throw new AbstractMethodException();
		}

		public function isEmpty():Boolean {
			return size() === 0;
		}

		public function put(key:Object, value:Object):Object {
			throw new UnsupportedOperationException();
		}

		public function get(key:Object):Object {
			var it:MapIterator = iterator();
			while (it.next()) {
				if (it.key === key) {
					return it.value;
				}
			}
			return null;
		}

		[Abstract]
		public function remove(key:Object):Object {
			var it:MapIterator = iterator();
			while (it.next()) {
				if (it.key === key) {
					var value:Object = it.value;
					it.remove();
					return value;
				}
			}
			return null;
		}

		public function containsKey(key:Object):Boolean {
			var it:MapIterator = iterator();
			while (it.next()) {
				if (it.key === key) {
					return true;
				}
			}
			return false;
		}

		public function containsValue(value:Object):Boolean {
			var it:MapIterator = iterator();
			while (it.next()) {
				if (it.value === value) {
					return true;
				}
			}
			return false;
		}

		[Abstract]
		public function iterator():MapIterator {
			throw new AbstractMethodException()
		}

		public function putAll(map:Object):void {
			//TODO
			throw new RuntimeException("TODO");
		}

		public function clear():void {
			var it:MapIterator = iterator();
			while (it.next()) {
				it.remove();
			}
		}

		[Abstract]
		public function entries():Vector.<MapEntry> {
			throw new AbstractMethodException();
		}

		public function keys():Vector.<Object> {
			//TODO
			throw new RuntimeException("TODO");
		}

		public function values():Vector.<Object> {
			//TODO
			throw new RuntimeException("TODO");
		}

		public function toString():String {
			if (isEmpty()) {
				return "{}";
			}

			var it:MapIterator = iterator();
			var string:String = "{";
			var sep:Boolean = false;
			while (it.next()) {
				if (sep) {
					string += ", ";
				}
				else {
					sep = true;
				}
				string += StringUtils.toString(it.key) + ": " + StringUtils.toString(it.value);
			}
			return string + "}";
		}

		///

		override flash_proxy function getProperty(name:*):* {
			throw new UnsupportedOperationException()
		}

		override flash_proxy function setProperty(name:*, value:*):void {
			throw new UnsupportedOperationException()
		}

		override flash_proxy function hasProperty(name:*):Boolean {
			throw new UnsupportedOperationException()
		}

		[Abstract]
		override flash_proxy function deleteProperty(name:*):Boolean {
			throw new AbstractMethodException()
		}

		[Abstract]
		override flash_proxy function nextNameIndex(index:int):int {
			throw new AbstractMethodException();
		}

		[Abstract]
		override flash_proxy function nextName(index:int):String {
			throw new AbstractMethodException();
		}

		[Abstract]
		override flash_proxy function nextValue(index:int):* {
			throw new AbstractMethodException();
		}

		override flash_proxy final function callProperty(name:*, ...rest):* {
			throw new UnsupportedOperationException()
		}

		override flash_proxy final function getDescendants(name:*):* {
			throw new UnsupportedOperationException()
		}

		override flash_proxy final function isAttribute(name:*):Boolean {
			throw new UnsupportedOperationException()
		}
	}
}
