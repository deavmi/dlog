/**
* Core module containing types pertaining to the base Logger
* class and base MessageTransform class (along with a default
* transform, DefaultTransform)
*/
module dlog.core;

import std.conv : to;
import std.range : join;
import dlog.transform : MessageTransform;
import dlog.defaults;

/**
* Logger
*
* Represents a logger instance
*/
public class Logger
{
	/* Starting transformation */
	private MessageTransform messageTransform;
	
	/* The multiple argument joiner */
	private string multiArgJoiner;

	/**
	* Constructs a new Logger with the default
	* MessageTransform, see TODO (ref module)
	*/
	this(string multiArgJoiner = " ")
	{
		this(new DefaultTransform(), multiArgJoiner);
	}

	/**
	* Constructs a new Logger with the given
	* MessageTransform
	*/
	this(MessageTransform messageTransform, string multiArgJoiner = " ")
	{
		this.messageTransform = messageTransform;
		this.multiArgJoiner = multiArgJoiner;
	}

	/**
	* Log a message
	*/
	public final void log(TextType...)(TextType message, string c1 = __FILE_FULL_PATH__,
									string c2 = __FILE__, ulong c3 = __LINE__,
									string c4 = __MODULE__, string c5 = __FUNCTION__,
									string c6 = __PRETTY_FUNCTION__, string[] contextExtras = null)
	{
		/* Construct context array */
		string[] context = [c1, c2, to!(string)(c3), c4, c5, c6]~contextExtras;

		/* Grab at compile-time all arguments and generate runtime code to add them to `components` */		
		string[] components;
		static foreach(messageComponent; message)
		{
			components ~= to!(string)(messageComponent);
		}

		/* Join all `components` into a single string */
		string messageOut = join(components, multiArgJoiner);
		
		/* Apply the transformation on the message */
		string transformedMesage = messageTransform.execute(messageOut, context);
		
		/* Call the underlying logger implementation */
		logImpl(transformedMesage);
	}

	/**
	* Logging implementation, this is where the fina
	* transformed text will be transferred to and finally
	* logged
	*/
	protected abstract void logImpl(string message);
}



/**
* Tests the DefaultLogger
*/
unittest
{
	Logger logger = new DefaultLogger();

	import std.meta;
	alias testParameters = AliasSeq!("This is a log message", 1.1, true, [1,2,3], 'f', logger);

	
	// Test various types one-by-one
	static foreach(testParameter; testParameters)
	{
		logger.log(testParameter);
	}

	// Test various parameters (of various types) all at once
	logger.log(testParameters);

	// Same as above but with a custom joiner set
	logger = new DefaultLogger("(-)");
	logger.log(testParameters);
}