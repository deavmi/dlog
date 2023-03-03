/**
* Default logger
*/
module dlog.defaults;

import dlog.core : Logger;
import dlog.transform : MessageTransform;
import dlog.context : Context, CompilationInfo;
import std.conv : to;

/**
* DefaultLogger
*
* The default logger logs to standard output (fd 0)
*/
public final class DefaultLogger : Logger
{
	/** 
	 * Constructs a new default logger
	 *
	 * Params:
	 *   multiArgJoiner = the joiner to use
	 */
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

/**
 * DefaultTransform
 *
 * Provides a transformation of the kind
 *
 * [date+time] (srcFile:lineNumber): message `\n`
 */
public final class DefaultTransform : MessageTransform
{
	/** 
	 * Performs the default transformation
	 *
	 * Params:
	 *   text = text input to transform
	 *   context = the context (if any)
	 * Returns: the transformed text
	 */
	public override string transform(string text, Context ctx)
	{
		/* Extract the context */
		string[] context = ctx.getLineInfo().toArray();

		string message;

		/* Date and time */
		import std.datetime.systime : Clock, SysTime;
		SysTime currTime = Clock.currTime();
		import std.conv : to;
		string timestamp = to!(string)(currTime);
		message = "["~timestamp~"]";

		/* Module information */
		message = message ~ "\t(";
		message = message ~ context[1]~":"~context[2];
		message = message ~ "): "~text;

		/* Add trailing newline */
		message = message ~ '\n';
		
		return message;
	}
}