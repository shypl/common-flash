package org.shypl.common.util {
	import flash.geom.Point;

	import org.shypl.common.lang.UnsupportedOperationException;

	public final class StaticPoint0 extends Point {
		public static const INSTANCE:Point = new StaticPoint0();

		public function StaticPoint0() {
			super(0, 0);
		}

		override public function offset(dx:Number, dy:Number):void {
			throw new UnsupportedOperationException();
		}

		override public function normalize(thickness:Number):void {
			throw new UnsupportedOperationException();
		}

		[API("674")]
		override public function copyFrom(sourcePoint:Point):void {
			throw new UnsupportedOperationException();
		}

		[API("674")]
		override public function setTo(xa:Number, ya:Number):void {
			throw new UnsupportedOperationException();
		}
	}
}
