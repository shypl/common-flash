package org.shypl.common.lang {
	public function newInstance(type:Class, arguments:Array):* {
		var a:Array = arguments;
		switch (a.length) {
			case 0:
				return new type();
			case 1:
				return new type(a[0]);
			case 2:
				return new type(a[0], a[1]);
			case 3:
				return new type(a[0], a[1], a[2]);
			case 4:
				return new type(a[0], a[1], a[2], a[3]);
			case 5:
				return new type(a[0], a[1], a[2], a[3], a[4]);
			case 6:
				return new type(a[0], a[1], a[2], a[3], a[4], a[5]);
			case 7:
				return new type(a[0], a[1], a[2], a[3], a[4], a[5], a[6]);
			case 8:
				return new type(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7]);
			case 9:
				return new type(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8]);
			case 10:
				return new type(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9]);
			case 11:
				return new type(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10]);
			case 12:
				return new type(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11]);
			case 13:
				return new type(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12]);
			case 14:
				return new type(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13]);
			case 15:
				return new type(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], a[14]);
			case 16:
				return new type(a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12], a[13], a[14], a[15]);
		}
		
		throw new IllegalOperationException("Unsupported number of Constructor arguments: " + a.length);
	}
}
