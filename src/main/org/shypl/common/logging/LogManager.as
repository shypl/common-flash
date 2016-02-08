package org.shypl.common.logging {
	import flash.utils.getQualifiedClassName;

	import org.shypl.common.collection.MapIterator;
	import org.shypl.common.collection.SortedMap;
	import org.shypl.common.collection.TreeMap;
	import org.shypl.common.lang.IllegalArgumentException;
	import org.shypl.common.util.SimpleComparator;
	import org.shypl.common.util.StringUtils;

	public final class LogManager {
		private static const loggers:SortedMap = new TreeMap(SimpleComparator.getInstance());
		private static const levels:SortedMap = new TreeMap(SimpleComparator.getInstance());

		private static var _output:Output = new TraceOutput();
		private static var _defaultLevel:Level = Level.INFO;

		public static function getLogger(o:Object):Logger {
			if (o is Class) {
				return getLoggerByClass(o as Class);
			}

			if (o is String) {
				return getLoggerByName(o as String);
			}

			throw new IllegalArgumentException();
		}

		public static function getLoggerByClass(cls:Class):Logger {
			return getLoggerByName(getQualifiedClassName(cls).replace("::", "."))
		}

		public static function getLoggerByName(name:String):Logger {
			if (StringUtils.isEmpty(name)) {
				throw new IllegalArgumentException();
			}

			var logger:LoggerImpl = LoggerImpl(loggers.get(name));
			if (logger === null) {
				logger = new LoggerImpl(name, getLevel(name));
				loggers.put(name, logger);
			}

			return logger;
		}

		public static function setOutput(output:Output):void {
			LogManager._output = output;
		}

		public static function setLevel(level:Level, path:String = null):void {
			const it:MapIterator = loggers.iterator();

			if (path === null) {
				_defaultLevel = level;

				while (it.next()) {
					LoggerImpl(it.value).setLevel(level);
				}
			}
			else {
				levels.put(path, level);

				var pathPrefix:String = path + ".";
				var br:Boolean = false;

				while (it.next()) {
					var loggerName:String = String(it.key);
					if (loggerName === path || StringUtils.startsWith(loggerName, pathPrefix)) {
						LoggerImpl(it.value).setLevel(level);
						br = true;
					}
					else if (br) {
						break;
					}
				}
			}
		}

		internal static function log(level:Level, logger:String, message:String):void {
			_output.write(level, logger, message);
		}

		private static function getLevel(name:String):Level {
			var level:Level;

			while (true) {
				level = Level(levels.get(name));
				if (level !== null) {
					return level
				}
				var i:int = name.lastIndexOf(".");
				if (i === -1) {
					break;
				}
				name = name.substring(0, i);
			}

			return _defaultLevel;
		}
	}
}



