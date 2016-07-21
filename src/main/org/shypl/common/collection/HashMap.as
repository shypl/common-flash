package org.shypl.common.collection {
	import flash.utils.Dictionary;
	import flash.utils.flash_proxy;
	
	import org.shypl.common.lang.IllegalStateException;
	
	use namespace flash_proxy;
	
	public class HashMap extends AbstractMap {
		internal var _dic:Dictionary = new Dictionary();
		internal var _size:int;
		internal var _modCount:int;
		
		public function HashMap() {
		}
		
		override public function size():int {
			return _size;
		}
		
		override public function put(key:Object, value:Object):* {
			var entry:MapEntryImpl;
			try {
				entry = _dic[key];
			}
			catch (e:Error) {
				entry = null;
			}
			
			if (entry === null) {
				addEntry(new MapEntryImpl(key, value));
				return null;
			}
			
			var v:Object = entry._value;
			entry._value = value;
			return v;
		}
		
		override public function get(key:Object):* {
			var entry:MapEntryImpl;
			try {
				entry = _dic[key];
			}
			catch (e:Error) {
				return null;
			}
			
			if (entry === null) {
				return null;
			}
			return entry._value;
		}
		
		override public function remove(key:Object):* {
			var entry:MapEntryImpl = _dic[key];
			if (entry === null) {
				return null;
			}
			
			return removeEntry(entry);
		}
		
		override public function containsKey(key:Object):Boolean {
			return key in _dic;
		}
		
		override public function containsValue(value:Object):Boolean {
			for each (var e:MapEntryImpl in _dic) {
				if (e._value === value) {
					return true;
				}
			}
			return false;
		}
		
		override public function iterator():MapIterator {
			return new HashMap_Iterator(this);
		}
		
		override public function clear():void {
			for each (var entry:MapEntryImpl in _dic) {
				entry.destroy();
			}
			_dic = new Dictionary();
			_size = 0;
			++_modCount;
		}
		
		protected function addEntry(entry:MapEntryImpl):void {
			_dic[entry._key] = entry;
			++_size;
			++_modCount;
		}
		
		protected function removeEntry(entry:MapEntryImpl):Object {
			var v:Object = entry._value;
			delete _dic[entry._key];
			entry.destroy();
			--_size;
			++_modCount;
			return v;
		}
		
		///
		
		flash_proxy var _flashProxyIterator:HashMap_FlashProxyIterator;
		
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
		
		override final flash_proxy function getProperty(name:*):* {
			return get(Utils.extractFlashProxyName(name));
		}
		
		override final flash_proxy function setProperty(name:*, value:*):void {
			checkFlashProxyIteratorNotExists();
			put(Utils.extractFlashProxyName(name), value);
		}
		
		override final flash_proxy function hasProperty(name:*):Boolean {
			return containsKey(Utils.extractFlashProxyName(name))
		}
		
		override final flash_proxy function deleteProperty(name:*):Boolean {
			checkFlashProxyIteratorNotExists();
			var key:String = Utils.extractFlashProxyName(name);
			if (containsKey(key)) {
				remove(key);
				return true;
			}
			return false;
		}
		
		override final flash_proxy function nextNameIndex(index:int):int {
			if (index === 0) {
				checkFlashProxyIteratorNotExists();
				
				if (_size === 0) {
					return 0;
				}
				
				_flashProxyIterator = new HashMap_FlashProxyIterator(this);
				return 1;
			}
			
			if (index < _size) {
				checkFlashProxyIteratorExists();
				return index + 1;
			}
			
			if (_flashProxyIterator !== null) {
				_flashProxyIterator.destroy();
				_flashProxyIterator = null;
			}
			
			return 0;
		}
		
		override final flash_proxy function nextName(index:int):String {
			checkFlashProxyIteratorExists();
			return _flashProxyIterator.getKey(index - 1);
		}
		
		override final flash_proxy function nextValue(index:int):* {
			checkFlashProxyIteratorExists();
			return _flashProxyIterator.getValue(index - 1);
		}
		
	}
}
