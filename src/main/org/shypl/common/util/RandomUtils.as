package org.shypl.common.util {
	import org.shypl.common.lang.IllegalArgumentException;

	public final class RandomUtils {

		public static function getInt():int {
			return getUint() - int.MAX_VALUE;
		}

		public static function getUint():uint {
			return Math.random() * uint.MAX_VALUE;
		}

		public static function getIntToBound(bound:int):int {
			return Math.random() * bound;
		}

		public static function getIntFromRange(min:int, max:int):int {
			return getIntToBound(max + 1 - min) + min;
		}

		public static function getIndexFromWeights(weightsCollection:Object, weightsSum:int = -1):int {
			return getIndexFromWeightsWitSum(weightsCollection, CollectionUtils.sum(weightsCollection));
		}

		public static function getIndexFromWeightsWitSum(weightsCollection:Object, weightsSum:int):int {
			if (!CollectionUtils.isArrayOrVector(weightsCollection)) {
				throw new IllegalArgumentException();
			}

			var rnd:int = getIntToBound(weightsSum);
			var i:int = 0;
			weightsSum = 0;

			for (var l:int = weightsCollection.length; i < l; ++i) {
				weightsSum += weightsCollection[i];
				if (weightsSum >= rnd) {
					return i;
				}
			}

			return i;
		}
	}
}
