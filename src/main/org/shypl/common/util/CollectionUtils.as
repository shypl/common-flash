package org.shypl.common.util {
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	import org.shypl.common.lang.IllegalArgumentException;
	import org.shypl.common.lang.NullPointerException;
	import org.shypl.common.lang.isEquals;
	
	public final class CollectionUtils {

		public static const VECTOR_CLASS_NAME:String = getQualifiedClassName(Vector);
		public static const VECTOR_CLASSES_CACHE:Dictionary = new Dictionary();

		public static function isVector(collection:Object):Boolean {
			if (collection === null) {
				throw new NullPointerException();
			}
			return isVector0(collection);
		}

		public static function isArrayOrVector(collection:Object):Boolean {
			if (collection === null) {
				throw new NullPointerException();
			}
			return collection is Array || isVector0(collection);
		}

		public static function isEmpty(collectionOrObject:Object):Boolean {
			if (collectionOrObject === null) {
				return true;
			}
			if (collectionOrObject is Array || isVector0(collectionOrObject)) {
				return collectionOrObject.length === 0;
			}

			for (var k:String in collectionOrObject) {
				if (collectionOrObject.hasOwnProperty(k)) {
					return false;
				}
			}

			return true;
		}

		public static function isEquals(collectionA:Object, collectionB:Object):Boolean {
			if (collectionA === collectionB) {
				return true;
			}
			if (!isArrayOrVector(collectionA) || !isArrayOrVector(collectionB)) {
				throw new IllegalArgumentException();
			}
			var length:uint = collectionA.length;

			if (length !== collectionB.length) {
				return false;
			}

			for (var i:uint = 0; i < length; ++i) {
				if (!org.shypl.common.lang.isEquals(collectionA[i], collectionB[i])) {
					return false;
				}
			}

			return true;
		}

		public static function isEqualsDeep(collectionA:Object, collectionB:Object):Boolean {
			if (collectionA === collectionB) {
				return true;
			}
			if (!isArrayOrVector(collectionA) || !isArrayOrVector(collectionB)) {
				throw new IllegalArgumentException();
			}
			var length:uint = collectionA.length;

			if (length !== collectionB.length) {
				return false;
			}

			for (var i:uint = 0; i < length; ++i) {
				var a:Object = collectionA[i];
				var b:Object = collectionB[i];
				if (!org.shypl.common.lang.isEquals(a, b) && isArrayOrVector(a) && isArrayOrVector(b) && !isEqualsDeep(a, b)) {
					return false;
				}
			}

			return true;
		}

		public static function contains(collection:Object, element:Object):Boolean {
			if (!isArrayOrVector(collection)) {
				throw new IllegalArgumentException();
			}
			return collection.indexOf(element) !== -1;
		}

		public static function addUnique(collection:Object, element:Object):Boolean {
			if (!isArrayOrVector(collection)) {
				throw new IllegalArgumentException();
			}

			if (contains(collection, element)) {
				return false;
			}
			collection.push(element);
			return true;
		}

		public static function shuffle(collection:Object):void {
			if (!isArrayOrVector(collection)) {
				throw new IllegalArgumentException();
			}
			for (var i:int = collection.length - 1; i >= 1; --i) {
				var p:int = Math.floor(Math.random() * i);
				var item:Object = collection[p];
				collection[p] = collection[i];
				collection[i] = item;
			}
		}

		public static function fill(collection:Object, value:Object):void {
			if (!isArrayOrVector(collection)) {
				throw new IllegalArgumentException();
			}
			for (var i:int = 0, l:int = collection.length; i < l; ++i) {
				collection[i] = value;
			}
		}

		public static function remove(collection:Object, element:Object):Boolean {
			if (!isArrayOrVector(collection)) {
				throw new IllegalArgumentException();
			}

			const i:int = collection.indexOf(element);
			if (i === -1) {
				return false;
			}
			collection.splice(i, 1);
			return true;
		}

		public static function clear(collectionOrObject:Object):void {
			if (collectionOrObject === null) {
				return;
			}

			if (collectionOrObject is Array) {
				collectionOrObject.length = 0;
			}
			else if (isVector0(collectionOrObject)) {
				collectionOrObject.fixed = false;
				collectionOrObject.length = 0;
			}
			else {
				for (var k:String in collectionOrObject) {
					delete collectionOrObject[k];
				}
			}
		}

		public static function sum(collection:Object):int {
			if (!isArrayOrVector(collection)) {
				throw new IllegalArgumentException();
			}

			var sum:int = 0;
			for (var i:int = 0, l:int = collection.length; i < l; ++i) {
				sum += collection[i];
			}
			return sum;
		}

		public static function sumUint(collection:Object):uint {
			if (!isArrayOrVector(collection)) {
				throw new IllegalArgumentException();
			}

			var sum:uint = 0;
			for (var i:int = 0, l:int = collection.length; i < l; ++i) {
				sum += collection[i];
			}
			return sum;
		}

		public static function sumNumber(collection:Object):Number {
			if (!isArrayOrVector(collection)) {
				throw new IllegalArgumentException();
			}

			var sum:Number = 0;
			for (var i:int = 0, l:int = collection.length; i < l; ++i) {
				sum += collection[i];
			}
			return sum;
		}

		public static function move(collection:Object, length:int, insertValue:Object = null):void {
			if (!isArrayOrVector(collection)) {
				throw new IllegalArgumentException();
			}

			var l:int = collection.length;

			if (l !== 0 && length !== 0) {
				var i:int;

				if (length > 0) {
					for (i = l - 1; i >= 0; i--) {
						collection[i] = i < length ? insertValue : collection[i - length];
					}
				}
				else {
					var q:int = l + length;
					for (i = 0; i < l; i++) {
						collection[i] = i >= q ? insertValue : collection[i - length];
					}
				}
			}
		}

		public static function getVectorClass(elementClass:Class):Class {
			var cls:Class = VECTOR_CLASSES_CACHE[elementClass];
			if (cls === null) {
				cls = Class(getDefinitionByName(VECTOR_CLASS_NAME + ".<" + getQualifiedClassName(elementClass) + ">"));
				VECTOR_CLASSES_CACHE[elementClass] = cls;
			}
			return cls;
		}

		public static function createVector(elementClass:Class, length:uint = 0, fixed:Boolean = false):* {
			return new (getVectorClass(elementClass))(length, fixed);
		}

		public static function createVectorAndFill(elementClass:Class, length:uint, value:Object, fixed:Boolean = false):* {
			var vector:Object = new (getVectorClass(elementClass))(length, fixed);
			fill(vector, value);
			return vector;
		}

		public static function arrayToVector(array:Array, elementClass:Class):Object {
			const vector:Object = createVector(elementClass, array.length, true);
			for (var i:int = 0; i < array.length; i++) {
				vector[i] = array[i];
			}
			return vector;
		}

		public static function vectorToArray(vector:Object):Array {
			if (!isVector(vector)) {
				throw new IllegalArgumentException();
			}

			const array:Array = new Array(vector.length);
			for (var i:int = 0; i < vector.length; i++) {
				array[i] = vector[i];
			}
			return array;
		}

		public static function objectKeysToArray(object:Object):Array {
			const array:Array = [];
			for (var key:String in object) {
				array.push(key);
			}
			return array;
		}

		public static function objectValuesToArray(object:Object):Array {
			const array:Array = [];
			for each (var value:Object in object) {
				array.push(value);
			}
			return array;
		}

		public static function objectKeysToVector(object:Object):Vector.<String> {
			const vector:Vector.<String> = new Vector.<String>();
			for (var key:String in object) {
				vector.push(key);
			}
			return vector;
		}

		public static function objectValuesToVector(object:Object, elementClass:Class):* {
			const vector:Object = createVector(elementClass, 0, false);
			for each (var value:Object in object) {
				vector.push(value);
			}
			return vector;
		}

		private static function isVector0(collection:Object):Boolean {
			return collection is Vector.<*>
				|| collection is Vector.<int>
				|| collection is Vector.<uint>
				|| collection is Vector.<Number>;
		}
	}
}
