package org.shypl.common.util {
	public interface DestroyableState extends Destroyable {
		function get destroyed():Boolean;

		function checkDestroyed():void;
	}
}
