module dlog.defaults;

import dlog.core : Logger;

/**
* DefaultLogger
*
* The default logger logs to standard output (fd 0)
*/
public final class DefaultLogger : Logger
{
	this()
	{
		/* Use the DefaultTransform */	
	}

	protected override void logImpl(string message)
	{
		import std.stdio : write;
		write(message);
	}
}
