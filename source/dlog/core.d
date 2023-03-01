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


	unittest
	{
		Logger logger = new DefaultLogger();

		alias testParameters = AliasSeq!("This is a log message", 1.1, true, [1,2,3], 'f', logger);


		// Same as above but with a custom joiner set
		logger = new DefaultLogger(" ");
		logger.log3(testParameters);
		Context ctx = new Context();
		logger.log3Ctx(ctx, testParameters);
	}

	import dlog.context;

	public final void log3(TextType...)(TextType segments, string c1 = __FILE_FULL_PATH__,
									string c2 = __FILE__, ulong c3 = __LINE__,
									string c4 = __MODULE__, string c5 = __FUNCTION__,
									string c6 = __PRETTY_FUNCTION__)
	{
		/* Use the default context `Context` */
		Context defaultContext = new Context();

		/* Build up the line information */
		CompilationInfo compilationInfo = CompilationInfo(c1, c2, c3, c4, c5, c6);

		/* Set the line information in the context */
		defaultContext.setLineInfo(compilationInfo);

		/* Call the log */
		log3Ctx(defaultContext, segments);
	}

	
	
	public final void log3Ctx(Context, TextType...)(Context context, TextType segments, string c1 = __FILE_FULL_PATH__,
									string c2 = __FILE__, ulong c3 = __LINE__,
									string c4 = __MODULE__, string c5 = __FUNCTION__,
									string c6 = __PRETTY_FUNCTION__)
	{
		/* Build up the line information */
		CompilationInfo compilationInfo = CompilationInfo(c1, c2, c3, c4, c5, c6);

		/* Set the line information in the context */
		context.setLineInfo(compilationInfo);
		
		/* Grab at compile-time all arguments and generate runtime code to add them to `components` */		
		string[] components;
		static foreach(messageComponent; segments)
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

	alias log = log3;
	alias logc = log3Ctx;

	// /**
	// * Log a message (default context))
	// */
	// public final void log(TextType...)(TextType message, string c1 = __FILE_FULL_PATH__,
	// 								string c2 = __FILE__, ulong c3 = __LINE__,
	// 								string c4 = __MODULE__, string c5 = __FUNCTION__,
	// 								string c6 = __PRETTY_FUNCTION__)
	// {
	// 	/* Default context extras is nothing */
	// 	string[] defaultContext = null;
		
	// 	/* Call the log */
	// 	logCtx(defaultContext, message);
	// }

	// /**
	// * Log a message
	// */
	// public final void logCtx(string[] ctx, TextType...)(string[] contextExtras, TextType message, string c1 = __FILE_FULL_PATH__,
	// 								string c2 = __FILE__, ulong c3 = __LINE__,
	// 								string c4 = __MODULE__, string c5 = __FUNCTION__,
	// 								string c6 = __PRETTY_FUNCTION__)
	// {
	// 	/* Construct context array */
	// 	string[] context = [c1, c2, to!(string)(c3), c4, c5, c6]~contextExtras;

	// 	/* Grab at compile-time all arguments and generate runtime code to add them to `components` */		
	// 	string[] components;
	// 	int metaLen = message[].length;
	// 	static foreach(messageComponent; message)
	// 	{
	// 		components ~= to!(string)(messageComponent);
	// 	}

	// 	/* Join all `components` into a single string */
	// 	string messageOut = join(components, multiArgJoiner);
		
	// 	/* Apply the transformation on the message */
	// 	string transformedMesage = messageTransform.execute(messageOut, context);
		
	// 	/* Call the underlying logger implementation */
	// 	logImpl(transformedMesage);
	// }

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

	// Logger logger = new DefaultLogger();

	// alias testParameters = AliasSeq!("This is a log message", 1.1, true, [1,2,3], 'f', logger);

	
	// // Test various types one-by-one
	// static foreach(testParameter; testParameters)
	// {
	// 	logger.log(["cool context"], testParameter);
	// }

	// // Test various parameters (of various types) all at once
	// logger.log(["cool context"], testParameters);

	// // Same as above but with a custom joiner set
	// logger = new DefaultLogger("(-)");
	// logger.log(["cool context"], testParameters);

	// writeln();
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
	// logger.log2(testParameters);

	// // Same as above but with a custom joiner set
	// logger = new DefaultLogger("(-)");
	// logger.log2(testParameters);
	
	// writeln();
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
	// logger.log2(testParameters);

	// // Same as above but with a custom joiner set
	// logger = new DefaultLogger("(-)");
	// logger.log2(testParameters, new Context());
	
	// writeln();
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
	// logger.log2(testParameters);

	// // Same as above but with a custom joiner set
	// logger = new DefaultLogger("(-)");
	// logger.log2(testParameters, CompilationInfo(__FILE_FULL_PATH__, __FILE__, __LINE__, __MODULE__, __FUNCTION__, __PRETTY_FUNCTION__));
	
	// writeln();
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
	// logger.log2(testParameters, new Context(), CompilationInfo(__FILE_FULL_PATH__, __FILE__, __LINE__, __MODULE__, __FUNCTION__, __PRETTY_FUNCTION__));
	
	writeln();
}

/**
 * Printing out some arrays, also using a DEFAULT context 
 */
unittest
{
	Logger logger = new DefaultLogger();

	// Same as above but with a custom joiner set
	logger = new DefaultLogger();
	logger.log(["a", "b", "c", "d"], [1, 2], true);

	writeln();
	writeln();
}

/**
 * Printing out some arrays, also using a CUSTOM context 
 */
unittest
{
	Logger logger = new DefaultLogger();

	// Same as above but with a custom joiner set
	logger = new DefaultLogger(" ");

	// Create a noticeable custom context
	// TODO: Actually make this somewhat noticeable
	Context customContext = new Context();

	// Log with the custom context
	logger.logc(customContext, ["an", "array"], 1, "hello", true);

	writeln();
	writeln();
}