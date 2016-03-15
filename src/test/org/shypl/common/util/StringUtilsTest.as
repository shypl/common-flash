package org.shypl.common.util {
	import org.shypl.common.assets.Asset;
	import org.shypl.flexunit.Assert;

	public class StringUtilsTest {
		[Test]
		public function testCount():void {
			Assert.assertEquals(0, StringUtils.count("", ""));
			Assert.assertEquals(0, StringUtils.count("", "asd"));
			Assert.assertEquals(0, StringUtils.count("asd", "123"));

			Assert.assertEquals(4, StringUtils.count("aa ss aa", "a"));
			Assert.assertEquals(2, StringUtils.count("aa ss aa", "aa"));

			Assert.assertEquals(2, StringUtils.count("111111", "111"));
		}

		[Test]
		public function testFormatSimple():void {
			Assert.assertEquals("", StringUtils.format(""));
			Assert.assertEquals("", StringUtils.format("", 1));
			Assert.assertEquals("123", StringUtils.format("123"));
			Assert.assertEquals("123", StringUtils.format("123", 1));
			Assert.assertEquals("123", StringUtils.format("{}23", 1));
			Assert.assertEquals("123", StringUtils.format("{}2{}", 1, 3));
			Assert.assertEquals("123", StringUtils.format("{}{}{}", 1, 2, 3));
		}
	}
}
