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
import dlog.context : Context, CompilationInfo;

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

	// TODO: Working on this
	public final void log2(TextType...)(TextType message, CompilationInfo compilationInfo = CompilationInfo(
																																			__FILE_FULL_PATH__,
																																			__FILE__,
																																			__LINE__,
																																			__MODULE__,
																																			__FUNCTION__,
																																			__PRETTY_FUNCTION__))
	{
		// Create default context
		Context context = new Context();

		// TODO: DO the same sort of grab for the CompilationInfo
		static foreach(messageComponent; message)
		{
			static if(__traits(isSame, typeof(messageComponent), mixin(`CompilationInfo`)))
			{
				compilationInfo = messageComponent;
				pragma(msg, "meta: log2 has a custom compilationInfo passed in");
			}
			else static if(__traits(isSame, typeof(messageComponent), mixin(`Context`)))
			{
				context = messageComponent;
				pragma(msg, "meta: generated a log2 with a CUSTOM context");
			}
		}

		// TODO: Gabd the context from the message[$] if it is of type Context (meta)
		
		
		


		/* Set the line information in the provided Context */
		context.setLineInfo(compilationInfo);

		/* Grab at compile-time all arguments and generate runtime code to add them to `components` */		
		string[] components;
		static foreach(messageComponent; message)
		{
			components ~= to!(string)(messageComponent);
		}

		/* Join all `components` into a single string */
		string messageOut = join(components, multiArgJoiner);

		// pragma(msg, styff);

		// TODO: Implement suff here
	}

	/**
	* Log a message
	*/
	public final void log(TextType...)(TextType message, string c1 = __FILE_FULL_PATH__,
									string c2 = __FILE__, ulong c3 = __LINE__,
									string c4 = __MODULE__, string c5 = __FUNCTION__,
									string c6 = __PRETTY_FUNCTION__)
	{
		/* Default context extras ios nothing */
		string[] contextExtras = null;
		static if(__traits(isSame, typeof(message[$-1]), mixin(`string[]`)))
		{
			contextExtras = message[$-1];
			version(unittest)
			{
				pragma(msg, "meta: log: Found a custom string[] context array");
			}
		}
		

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
	writeln();
	writeln();

	Logger logger = new DefaultLogger();

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

	writeln();
}

/**
* Tests the DefaultLogger but custom `log()` context
*/
unittest
{
	writeln();
	writeln();

	Logger logger = new DefaultLogger();

	alias testParameters = AliasSeq!("This is a log message", 1.1, true, [1,2,3], 'f', logger);

	
	// Test various types one-by-one
	static foreach(testParameter; testParameters)
	{
		logger.log(testParameter, ["cool context"]);
	}

	// Test various parameters (of various types) all at once
	logger.log(testParameters, ["cool context"]);

	// Same as above but with a custom joiner set
	logger = new DefaultLogger("(-)");
	logger.log(testParameters, ["cool context"]);

	writeln();
}

/**
* Tests the `log2()` method using the DefaultLogger
* and no custom Context
*/
unittest
{
	writeln();
	writeln();

	Logger logger = new DefaultLogger();

	alias testParameters = AliasSeq!("This is a log message", 1.1, true, [1,2,3], 'f', logger);

	// Test various parameters (of various types) all at once
	logger.log2(testParameters);

	// Same as above but with a custom joiner set
	logger = new DefaultLogger("(-)");
	logger.log2(testParameters);
	
	writeln();
}

/**
* Tests the `log2()` method using the DefaultLogger
* and using a custom Context
*/
unittest
{
	writeln();
	writeln();

	Logger logger = new DefaultLogger();

	alias testParameters = AliasSeq!("This is a log message", 1.1, true, [1,2,3], 'f', logger);

	// Test various parameters (of various types) all at once
	logger.log2(testParameters);

	// Same as above but with a custom joiner set
	logger = new DefaultLogger("(-)");
	logger.log2(testParameters, new Context());
	
	writeln();
}

/**
* Tests the `log2()` method using the DefaultLogger
* and using a custom CompilationInfo
*/
unittest
{
	writeln();
	writeln();

	Logger logger = new DefaultLogger();

	alias testParameters = AliasSeq!("This is a log message", 1.1, true, [1,2,3], 'f', logger);

	// Test various parameters (of various types) all at once
	logger.log2(testParameters);

	// Same as above but with a custom joiner set
	logger = new DefaultLogger("(-)");
	logger.log2(testParameters, CompilationInfo(__FILE_FULL_PATH__, __FILE__, __LINE__, __MODULE__, __FUNCTION__, __PRETTY_FUNCTION__));
	
	writeln();
}

/**
* Tests the `log2()` method using the DefaultLogger
* and using a custom CompilationInfo and custom context
*/
unittest
{
	writeln();
	writeln();

	Logger logger = new DefaultLogger();

	alias testParameters = AliasSeq!("This is a log message", 1.1, true, [1,2,3], 'f', logger);


	// Same as above but with a custom joiner set
	logger = new DefaultLogger("(-)");
	logger.log2(testParameters, new Context(), CompilationInfo(__FILE_FULL_PATH__, __FILE__, __LINE__, __MODULE__, __FUNCTION__, __PRETTY_FUNCTION__));
	
	writeln();
}