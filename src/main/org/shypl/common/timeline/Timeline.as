package org.shypl.common.timeline {
	import org.shypl.common.collection.LiteLinkedSet;
	import org.shypl.common.lang.IllegalStateException;
	import org.shypl.common.lang.RuntimeException;
	import org.shypl.common.util.Cancelable;

	public class Timeline {
		private var _tasks:LiteLinkedSet = new LiteLinkedSet();
		private var _running:Boolean = true;
		private var _stopped:Boolean;
		private var _lastFrameTime:int;

		public function Timeline() {
			Engine.addTimeline(this);
		}

		public final function get lastFrameTime():int {
			return _lastFrameTime;
		}

		protected final function get dispatching():Boolean {
			return Engine.dispatching;
		}

		public final function schedule(delay:int, task:Function, obtainTime:Boolean = false):Cancelable {
			return addTask(new ScheduledTask(task, obtainTime, false, delay));
		}

		public final function scheduleRepeatable(delay:int, task:Function, obtainTime:Boolean = false):Cancelable {
			return addTask(new ScheduledTask(task, obtainTime, true, delay));
		}

		public final function forNextFrame(task:Function, obtainTime:Boolean = false):Cancelable {
			return addTask(new Task(task, obtainTime, false));
		}

		public final function forEachFrame(task:Function, obtainTime:Boolean = false):Cancelable {
			return addTask(new Task(task, obtainTime, true));
		}

		public final function clear():void {
			if (dispatching) {
				Engine.addChange(new TimelineChange(this, TimelineChange.CLEAR));
			}
			else {
				doClear();
			}
		}

		public final function stop():void {
			if (!_stopped) {
				if (dispatching) {
					Engine.addChange(new TimelineChange(this, TimelineChange.STOP));
				}
				else {
					doStop();
				}
			}
		}

		public final function pause():void {
			if (dispatching) {
				Engine.addChange(new TimelineChange(this, TimelineChange.PAUSE));
			}
			else {
				doPause();
			}
		}

		public final function resume():void {
			if (dispatching) {
				Engine.addChange(new TimelineChange(this, TimelineChange.RESUME));
			}
			else {
				doResume();
			}
		}

		protected function doClear():void {
			checkStopped();
			Engine.decreaseTaskCounter(_tasks.size());
			_tasks.clear();
		}

		protected function doStop():void {
			doClear();
			Engine.removeTimeline(this);
			_tasks = null;
			_stopped = true;
		}

		protected function doPause():void {
			checkStopped();
			_running = false;
		}

		protected function doResume():void {
			checkStopped();
			_running = true;
		}

		internal function checkStopped():void {
			if (_stopped) {
				throw new IllegalStateException("Timeline is stopped");
			}
		}

		internal function handleEnterFrame(time:int):void {
			if (_running) {
				_lastFrameTime = time;
				var removeCount:int = 0;

				while (_tasks.next()) {
					var task:Task = Task(_tasks.current);
					if (task.canceled) {
						_tasks.removeCurrent();
						++removeCount;
					}
					else {
						try {
							task.handleEnterFrame(time);
						}
						catch (error:Error) {
							task.cancel();
							_tasks.removeCurrent();
							_tasks.stopIteration();
							Engine.decreaseTaskCounter(++removeCount);

							throw error;
						}

						if (task.canceled) {
							_tasks.removeCurrent();
							++removeCount;
						}
					}
				}

				Engine.decreaseTaskCounter(removeCount);
			}
		}

		internal function addTask(task:Task):Cancelable {
			if (dispatching) {
				Engine.addChange(new TimelineChangeAddTask(this, task));
			}
			else {
				checkStopped();
				_tasks.add(task);
				Engine.increaseTaskCounter();
			}

			return task;
		}
	}
}
