package org.shypl.common.timeline {
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getTimer;

	import org.shypl.common.collection.LiteLinkedList;
	import org.shypl.common.util.Cancelable;
	import org.shypl.common.util.Executor;

	public class Timeline {
		private static const SHAPE:Shape = new Shape();

		private var _running:Boolean = true;
		private var _changer:Executor = new Executor();

		private var _frameTasks:LiteLinkedList = new LiteLinkedList();
		private var _prevFrameTime:int;

		public function Timeline() {
		}

		public final function addFrameTask(task:FrameTask):Cancelable {
			_changer.executeFunction(function ():void {
				doAddFrameTask(task);
			});
		}

		public final function addTimeTask(task:TimeTask):Cancelable {
			_changer.executeFunction(function ():void {
				doAddTimeTask(task);
			});
		}

		private function doAddFrameTask(task:FrameTask):void {
			bindFrameListenerIfNeeded();
			_frameTasks.add(task);
		}

		private function doAddTimeTask(task:TimeTask):void {

		}

		private function bindFrameListenerIfNeeded():void {
			if (_frameTasks.isEmpty()) {
				_prevFrameTime = getTimer();
				SHAPE.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}

		private function unbindFrameListenerIfNeeded():void {
			if (_frameTasks.isEmpty()) {
				SHAPE.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}

		private function handleFrame():void {
			var currentFrameTime:int = getTimer();
			var passedTime:int = currentFrameTime - _prevFrameTime;
			_prevFrameTime = currentFrameTime;

			if (_running) {
				processTasks(_frameTasks, passedTime);
			}
		}

		private function processTasks(tasks:LiteLinkedList, passedTime:int):void {
			_changer.lock();
			try {
				while (tasks.next()) {
					var task:Task = Task(tasks.current);
					var remove:Boolean = true;

					try {
						remove = task.tryExecuteAndGetCanceled(passedTime);
					}
					catch (error:Error) {
						try {
							task.cancel();
						}
						catch (ignored:Error) {
						}

						tasks.stopIteration();
						_changer.unlock();

						throw error;
					}

					if (remove) {
						tasks.removeCurrent();
					}
				}
			}
			finally {
				_changer.unlock();
				unbindFrameListenerIfNeeded();
			}
		}

		private function onEnterFrame(event:Event):void {
			handleFrame();
		}
	}
}
