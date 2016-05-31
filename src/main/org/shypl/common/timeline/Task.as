package org.shypl.common.timeline {
	import org.shypl.common.util.Cancelable;

	public interface Task extends Cancelable {
		function execute(time:int):Boolean;
	}
}
