/**
 * Default logger
 *
 * Authors: Tristan Brice Velloza Kildaire (deavmi)
 */
module dlog.defaults;

import dlog.core;
import dlog.basic : BasicMessage, FileHandler, Level;
import std.stdio : stdout;
import std.conv : to;
import dlog.utilities : flatten;
import std.array :join;
import std.datetime.systime : Clock, SysTime;

/**
* DefaultLogger
*
* The default logger logs using
* a pretty stock-standard (non-colored)
* message transformation and supports
* the basic levels of logging.
*/
public final class DefaultLogger : Logger
{
	/** 
	 * The joiner for multi-argument
	 * log messages
	 */
	private string multiArgJoiner;

	/** 
	 * Constructs a new default logger
	 *
	 * Params:
	 *   multiArgJoiner = the joiner to use
	 */
	this(string multiArgJoiner = " ")
	{
		this.multiArgJoiner = multiArgJoiner;
		
		addTransform(new DefaultTransform());
		addHandler(new FileHandler(stdout));
	}

	/** 
	 * Logs the given message of an arbitrary amount of
	 * arguments and specifically sets the level to ERROR
	 *
	 * Params:
	 *   segments = the arbitrary argumnets (alias sequence)
	 */
	public void error(TextType...)(TextType segments)
	{
		doLog(segments, Level.ERROR);
	}

	/** 
	 * Logs the given message of an arbitrary amount of
	 * arguments and specifically sets the level to INFO
	 *
	 * Params:
	 *   segments = the arbitrary argumnets (alias sequence)
	 */
	public void info(TextType...)(TextType segments)
	{
		doLog(segments, Level.INFO);
	}

	/** 
	 * Logs the given message of an arbitrary amount of
	 * arguments and specifically sets the level to WARN
	 *
	 * Params:
	 *   segments = the arbitrary argumnets (alias sequence)
	 */
	public void warn(TextType...)(TextType segments)
	{
		doLog(segments, Level.WARN);
	}

	/** 
	 * Logs the given message of an arbitrary amount of
	 * arguments and specifically sets the level to DEBUG
	 *
	 * Params:
	 *   segments = the arbitrary argumnets (alias sequence)
	 */
	public void debug_(TextType...)(TextType segments)
	{
		doLog(segments, Level.DEBUG);
	}

	/** 
     * Performs the actual logging
     * by packing up everything before
     * sending it to the `log(Message)`
     * method
     *
     * Params:
     *   segments = the compile-time segments
     *   level = the log level to use
     */
    private void doLog(TextType...)(TextType segments, Level level)
    {
        /* Create a new basic message */
        BasicMessage message = new BasicMessage();

        /* Set the level */
        message.setLevel(level);

        /** 
         * Grab all compile-time arguments and make them
         * into an array, then join them together and
         * set that text as the message's text
         */
        message.setText(join(flatten(segments), multiArgJoiner));

        /* Log this message */
		log(message);
    }

	/** 
	 * Alias for debug_
	 */
	public alias dbg = debug_;
}

/**
 * DefaultTransform
 *
 * Provides a transformation of the kind
 *
 * [date+time] (level): message `\n`
 */
private final class DefaultTransform : Transform
{
	/** 
	 * Performs the default transformation.
	 * If the message is not a `BasicMessage`
	 * then no transformation occurs.
	 *
	 * Params:
	 *   message = the message to transform
	 * Returns: the transformed message
	 */
	public Message transform(Message message)
	{
		// Only handle BasicMessage(s)
		BasicMessage bmesg = cast(BasicMessage)message;
		if(bmesg is null)
		{
			return message;
		}

		string text;

		/* Date and time */
		SysTime currTime = Clock.currTime();
		string timestamp = to!(string)(currTime);
		text = "["~timestamp~"]";

		/* Level */
		text = text ~ "\t(";
		text = text ~ to!(string)(bmesg.getLevel());
		text = text ~ "): "~bmesg.getText();

		/* Add trailing newline */
		text = text ~ '\n';
		
		/* Store the updated text */
		bmesg.setText(text);

		return message;
	}
}

version(unittest)
{
	import std.meta : AliasSeq;
	import std.stdio : writeln;
}

/**
* Tests the DefaultLogger
*/
unittest
{
	DefaultLogger logger = new DefaultLogger();

	alias testParameters = AliasSeq!("This is a log message", 1.1, true, [1,2,3], 'f', logger);

	
	// Test various types one-by-one
	static foreach(testParameter; testParameters)
	{
		logger.info(testParameter);
	}

	// Test various parameters (of various types) all at once
	logger.info(testParameters);

	// Same as above but with a custom joiner set
	logger = new DefaultLogger("(-)");
	logger.info(testParameters);

	writeln();
}

/**
 * Printing out some mixed data-types, also using a DEFAULT context 
 */
unittest
{
	DefaultLogger logger = new DefaultLogger();

	// Create a default logger with the default joiner
	logger = new DefaultLogger();
	logger.info(["a", "b", "c", "d"], [1, 2], true);

	writeln();
}

/**
 * Printing out some mixed data-types, also using a DEFAULT context
 * but also testing out the `error()`, `warn()`, `info()` and `debug()`
 */
unittest
{
	DefaultLogger logger = new DefaultLogger();

	// Create a default logger with the default joiner
	logger = new DefaultLogger();

	// Test out `error()`
	logger.error(["woah", "LEVELS!"], 69.420);

	// Test out `info()`
	logger.info(["woah", "LEVELS!"], 69.420);

	// Test out `warn()`
	logger.warn(["woah", "LEVELS!"], 69.420);

	// Test out `debug_()`
	logger.debug_(["woah", "LEVELS!"], 69.420);

	writeln();
}