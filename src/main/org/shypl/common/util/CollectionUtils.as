package org.shypl.common.util {
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	import org.shypl.common.lang.IllegalArgumentException;
	import org.shypl.common.lang.NullPointerException;

	public final class CollectionUtils {

		public static const VECTOR_CLASS_NAME:String = getQualifiedClassName(Vector);

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
				if (collectionA[i] !== collectionB[i]) {
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
				if (a !== b && isArrayOrVector(a) && isArrayOrVector(b) && !isEqualsDeep(a, b)) {
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

		public static function getVectorClass(elementClass:Class):Class {
			return Class(getDefinitionByName(VECTOR_CLASS_NAME + ".<" + getQualifiedClassName(elementClass) + ">"));
		}

		public static function createVector(elementClass:Class, length:uint = 0, fixed:Boolean = false):Object {
			return new (getVectorClass(elementClass))(length, fixed);
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

		public static function objectValuesToVector(object:Object, elementClass:Class):Object {
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
