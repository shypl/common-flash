package org.shypl.common.math {
	import org.shypl.common.lang.IllegalArgumentException;

	public class NumberFormatException extends IllegalArgumentException {
		internal static function forInput(s:String):NumberFormatException {
			return new NumberFormatException("For input string: \"" + s + "\"");
		}

		internal static function tooLarge(s:String):NumberFormatException {
			return new NumberFormatException("Too large value for a Long: \"" + s + "\"");
		}

		public function NumberFormatException(message:String = null) {
			super(message);
		}
	}
}
