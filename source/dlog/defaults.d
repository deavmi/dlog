/**
* Includes defaults such as the DefaultLogger
*/
module dlog.defaults;

import dlog.core : Logger;

/**
* DefaultLogger
*
* The default logger logs to standard output (fd 0)
*/
public final class DefaultLogger : Logger
{
	this(string multiArgJoiner = " ")
	{
		/* Use the DefaultTransform */	
		super(multiArgJoiner);
	}

	protected override void logImpl(string message)
	{
		import std.stdio : write;
		write(message);
	}
}
