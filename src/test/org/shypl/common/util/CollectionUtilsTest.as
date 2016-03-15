package org.shypl.common.util {
	import org.shypl.flexunit.Assert;

	public class CollectionUtilsTest {
		[Test]
		public function testMove():void {
			var array:Vector.<int>;

			array = new <int>[1, 2, 3];
			CollectionUtils.move(array, 1);
			Assert.assertArrayEquals(new <int>[0, 1, 2], array);

			CollectionUtils.move(array, -1);
			Assert.assertArrayEquals(new <int>[1, 2, 0], array);
		}
	}
}
