package org.shypl.common.util.numerator {
	import org.shypl.common.lang.AbstractMethodException;
	import org.shypl.common.timeline.GlobalTimeline;
	import org.shypl.common.timeline.Timeline;
	import org.shypl.common.util.Cancelable;
	
	[Abstract]
	public class Numerator {
		private var _handler:NumeratorHandler;
		private var _timeline:Timeline;
		private var _stepTime:int;
		
		private var _sourceValue:Object;
		private var _targetValue:Object;
		private var _currentValue:Object;
		private var _stepValue:Object;
		private var _stepDiffValue:Object;
		
		private var _running:Boolean;
		private var _increase:Boolean;
		private var _step:uint;
		private var _updater:Cancelable;
		
		public function Numerator(handler:NumeratorHandler, sourceValue:Object, timeline:Timeline = null, stepTime:int = 0) {
			_handler = handler;
			_sourceValue = sourceValue;
			_targetValue = sourceValue;
			_currentValue = sourceValue;
			_stepValue = getZeroValue();
			_stepDiffValue = getZeroValue();
			
			_timeline = timeline === null ? GlobalTimeline.INSTANCE : timeline;
			_stepTime = stepTime;
		}
		
		public final function get sourceValue():Object {
			return _sourceValue;
		}
		
		public final function get currentValue():Object {
			return _currentValue;
		}
		
		public final function get targetValue():Object {
			return _targetValue;
		}
		
		public final function get step():uint {
			return _step;
		}
		
		public final function get stepValue():Object {
			return _stepValue;
		}
		
		public final function get stepDiffValue():Object {
			return _stepDiffValue;
		}
		
		public final function isIncrease():Boolean {
			return _increase;
		}
		
		public final function run(target:Object):void {
			_sourceValue = _currentValue;
			_targetValue = target;
			_step = 0;
			
			var comp:int = compare(_targetValue, _sourceValue);
			_increase = comp == 1;
			
			if (_running) {
				if (comp == 0) {
					doEnd();
				}
			}
			else {
				if (comp != 0) {
					doStart();
				}
			}
		}
		
		public final function set(target:Object):void {
			if (_running) {
				doEnd();
			}
			_sourceValue = target;
			_targetValue = target;
			_currentValue = target;
		}
		
		public final function complete():void {
			if (_running) {
				doEnd();
			}
		}
		
		protected function doStart():void {
			_running = true;
			_handler.handleNumerationStart(this);
			_updater = _stepTime <= 0 ? _timeline.forEachFrame(doStep) : _timeline.scheduleRepeatable(_stepTime, doStep);
		}
		
		protected function doStep():void {
			++_step;
			_stepDiffValue = isIncrease() ? subtract(_targetValue, _currentValue) : subtract(_currentValue, _targetValue);
			_stepValue = calculateStepValue();
			
			if (compare(_stepValue, _stepDiffValue) == 1) {
				_stepValue = _stepDiffValue;
			}
			
			_currentValue = isIncrease() ? sum(_currentValue, _stepValue) : subtract(_currentValue, _stepValue);
			_handler.handleNumerationStep(this);
			
			if (compare(_currentValue, _targetValue) == 0) {
				doEnd();
			}
		}
		
		protected function doEnd():void {
			_updater.cancel();
			_updater = null;
			_step = 0;
			_running = false;
			_currentValue = _targetValue;
			_handler.handleNumerationEnd(this);
			_sourceValue = _currentValue;
		}
		
		[Abstract]
		protected function getZeroValue():Object {
			throw new AbstractMethodException();
		}
		
		[Abstract]
		protected function sum(a:Object, b:Object):Object {
			throw new AbstractMethodException();
		}
		
		[Abstract]
		protected function subtract(a:Object, b:Object):Object {
			throw new AbstractMethodException();
		}
		
		[Abstract]
		protected function compare(a:Object, b:Object):int {
			throw new AbstractMethodException();
		}
		
		[Abstract]
		protected function calculateStepValue():Object {
			throw new AbstractMethodException();
		}
	}
}
