package org.shypl.common.loader {
	public class EmptyLoadingFailHandler implements LoadingFailHandler {
		public static const INSTANCE:LoadingFailHandler = new EmptyLoadingFailHandler();
		
		public function handleLoadingFail(url:String):void {
		}
	}
}
