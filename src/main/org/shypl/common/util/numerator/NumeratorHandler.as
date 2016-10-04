package org.shypl.common.util.numerator {
	public interface NumeratorHandler {
		function handleNumerationStart(numerator:Numerator):void;
		
		function handleNumerationStep(numerator:Numerator):void;
		
		function handleNumerationEnd(numerator:Numerator):void;
	}
}
