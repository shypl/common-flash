package org.shypl.common.util {
	import org.shypl.flexunit.Assert;

	public class CollectionUtilsTest {
		[Test]
		public function testMoveDown():void {
			var array:Vector.<int> = new <int>[1, 2, 3];
			CollectionUtils.move(array, 1);
			Assert.assertArrayEquals(new <int>[0, 1, 2], array);
		}

		[Test]
		public function testMoveUp():void {
			var array:Vector.<int> = new <int>[1, 2, 3];
			CollectionUtils.move(array, -1);
			Assert.assertArrayEquals(new <int>[2, 3, 0], array);
		}
	}
}
