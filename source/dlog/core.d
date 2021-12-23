module dlog.core;

import std.conv : to;
import dlog.defaults;

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
	* Our transformation
	*/
	public override string transform(string text, string[] context)
	{
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

/**
* Logger
*
* Represents a logger instance
*/
public class Logger
{
	/* Starting transformation */
	private MessageTransform messageTransform;
	
	/**
	* Constructs a new Logger with the default
	* MessageTransform, see TODO (ref module)
	*/
	this()
	{
		this(new DefaultTransform());
	}

	/**
	* Constructs a new Logger with the given
	* MessageTransform
	*/
	this(MessageTransform messageTransform)
	{
		this.messageTransform = messageTransform;
	}

	/**
	* Log a message
	*/
	public final void log(TextType)(TextType message, string c1 = __FILE_FULL_PATH__,
									string c2 = __FILE__, ulong c3 = __LINE__,
									string c4 = __MODULE__, string c5 = __FUNCTION__,
									string c6 = __PRETTY_FUNCTION__, string[] contextExtras = null)
	{
		/* Construct context array */
		string[] context = [c1, c2, to!(string)(c3), c4, c5, c6]~contextExtras;
		
		/* Apply the transformation on the message */
		string transformedMesage = messageTransform.execute(to!(string)(message), context);
		
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
* MessageTransform
*
* A message transform takes in text, applies
* a transformation to it and outputs said text
*
* Transforms may be chained
*/
public abstract class MessageTransform
{
	/* Next transformation (if any) */
	private MessageTransform chainedTransform;

	/**
	* The actual textual transformation.
	*
	* This is to be implemented by sub-classes
	*/
	public abstract string transform(string text, string[] context);

	/**
	* Chain a transform
	*/
	public final void chain(MessageTransform transform)
	{
		chainedTransform = transform;
	}

	/**
	* Perform the transformation
	*/
	public final string execute(string text, string[] context)
	{
		/* Perform the transformation */
		string transformedText = transform(text, context);

		/* If there is a chained transformation */
		if(chainedTransform)
		{
			transformedText = chainedTransform.execute(transformedText, context);
		}

		return transformedText;
	}
}

/**
* Tests the DefaultLogger
*/
unittest
{
	Logger logger = new DefaultLogger();

	logger.log("This is a log message");
	logger.log(1);
	logger.log(1.1);
	logger.log(true);
	logger.log([1,2,3]);
	logger.log('f');
	logger.log(logger);
}
