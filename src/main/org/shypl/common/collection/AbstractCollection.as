package org.shypl.common.collection {
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	import org.shypl.common.lang.AbstractMethodException;
	import org.shypl.common.lang.IllegalStateException;
	import org.shypl.common.lang.UnsupportedOperationException;
	import org.shypl.common.util.CollectionUtils;
	import org.shypl.common.util.StringUtils;

	use namespace flash_proxy;

	[Abstract]
	public class AbstractCollection extends Proxy implements Collection {
		public function AbstractCollection() {
		}

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

		public function clear():void {
			var it:Iterator = iterator();
			while (it.next()) {
				it.remove();
			}
		}

		[Abstract]
		public function add(element:Object):Boolean {
			throw new AbstractMethodException();
		}

		public function addAll(collection:Object):Boolean {
			var modified:Boolean = false;
			for each (var element:Object in collection) {
				if (add(element)) {
					modified = true;
				}
			}
			return modified;
		}

		public function contains(element:Object):Boolean {
			for each (var e:Object in this) {
				if (e === element) {
					return true;
				}
			}
			return false;
		}

		public function containsAll(collection:Object):Boolean {
			for each (var element:Object in collection) {
				if (!contains(element)) {
					return false;
				}
			}
			return true;
		}

		public function remove(element:Object):Boolean {
			var it:Iterator = iterator();
			while (it.next()) {
				if (it.element === element) {
					it.remove();
					return true;
				}
			}
			return false;
		}

		public function removeAll(collection:Object):Boolean {
			var modified:Boolean;
			var element:Object;

			if (size() > collection.length) {
				for each (element in collection) {
					if (remove(element)) {
						modified = true;
					}
				}
			}
			else {
				var isCollection:Boolean = contains is Collection;
				if (isCollection) {
					var cln:Collection = Collection(collection);
				}

				var it:Iterator = iterator();
				while (it.next()) {
					element = it.element;
					if (isCollection ? (cln.contains(element)) : (collection.indexOf(element) !== -1)) {
						it.remove();
						modified = true;
					}
				}
			}
			return modified;
		}

		public function toArray():Array {
			var array:Array = [];
			for each (var e:Object in this) {
				array.push(e);
			}
			return array;
		}

		public function toVector(elementClass:Class):Object {
			var vector:Object = CollectionUtils.createVector(elementClass, size(), true);
			var i:int = 0;
			for each (var e:Object in this) {
				vector[i++] = e;
			}
			return vector;
		}

		public function toString():String {
			if (isEmpty()) {
				return "[]";
			}

			var string:String = "[";
			var sep:Boolean = false;
			for each (var e:Object in this) {
				if (sep) {
					string += ", ";
				}
				else {
					sep = true;
				}
				string += StringUtils.toString(e);
			}

			return string + "]";
		}

		[Abstract]
		public function iterator():Iterator {
			throw new AbstractMethodException();
		}

		///
		flash_proxy var _flashProxyIterator:Iterator;

		final flash_proxy function checkFlashProxyIteratorExists():void {
			if (_flashProxyIterator === null) {
				throw new IllegalStateException();
			}
		}

		final flash_proxy function checkFlashProxyIteratorNotExists():void {
			if (_flashProxyIterator !== null) {
				throw new IllegalStateException();
			}
		}

		override flash_proxy function getProperty(name:*):* {
			throw new UnsupportedOperationException();
		}

		override flash_proxy function setProperty(name:*, value:*):void {
			throw new UnsupportedOperationException();
		}

		override flash_proxy function nextNameIndex(index:int):int {
			if (index === 0) {
				checkFlashProxyIteratorNotExists();

				if (isEmpty()) {
					return 0;
				}

				_flashProxyIterator = iterator();
				_flashProxyIterator.next();
				return 1;
			}

			if (index < size()) {
				checkFlashProxyIteratorExists();
				return _flashProxyIterator.next() ? (index + 1) : 0;
			}

			if (_flashProxyIterator !== null) {
				_flashProxyIterator = null;
			}

			return 0;
		}

		override flash_proxy function nextValue(index:int):* {
			checkFlashProxyIteratorExists();
			return _flashProxyIterator.element;
		}

		override flash_proxy final function nextName(index:int):String {
			throw new UnsupportedOperationException();
		}

		override final flash_proxy function hasProperty(name:*):Boolean {
			throw new UnsupportedOperationException();
		}

		override flash_proxy final function callProperty(name:*, ...rest):* {
			throw new UnsupportedOperationException()
		}

		override flash_proxy final function deleteProperty(name:*):Boolean {
			throw new UnsupportedOperationException();
		}

		override flash_proxy final function getDescendants(name:*):* {
			throw new UnsupportedOperationException();
		}

		override flash_proxy final function isAttribute(name:*):Boolean {
			throw new UnsupportedOperationException();
		}
	}
}
