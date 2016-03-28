package org.shypl.common.util {
	import flash.utils.setTimeout;

	public function callDelayed(closure:Function, ...args):void {
		if (args.length === 0) {
			setTimeout(closure, 1)
		}
		else {
			setTimeout.apply(null, [closure, 1].concat(args));
		}
	}
}
