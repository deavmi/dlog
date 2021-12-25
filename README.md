![](branding/logo.png)

dlog
====

**Simple and modular logging library**

`[2021-Dec-23 11:17:35.3527637]	(source/dlog/testing/thing.d:12): This is a log message`

---

## Usage

We recommend you use [dub](http://code.dlang.org) to add dlog to your project as follows:

```
dub add dlog
```

* [View on DUB](https://code.dlang.org/packages/dlog)
* [View API](https://dlog.dpldocs.info/)

### Components

dlog is formed out of two main components:

1. `Logger`
	* The logger contains the needed barebones for facilitating the actual logging of text
2. `MessageTransform`
	* A MessageTransform is attached to a logger and performs manipulation on the text input into the logger for logging
	* They may be chained as to perform multiple transformations in a stream-like fashion

### Quick start

If you want to immediately begin logging text usin the defaults and don't care about implementing your own transformations then you can 
simply use the default logger as follows:

```d
import dlog;

Logger logger = new DefaultLogger();


logger.log("This is a log message");
logger.log(1);
logger.log(1==1);
logger.log([1,2,3]);
```

This will output the following:

```
[2021-Dec-23 11:17:35.3527637]	(source/dlog/testing/thing.d:12): This is a log message
[2021-Dec-23 11:17:35.3527717]	(source/dlog/testing/thing.d:13): 1
[2021-Dec-23 11:17:35.3527789]	(source/dlog/testing/thing.d:14): true
[2021-Dec-23 11:17:35.3527871]	(source/dlog/testing/thing.d:15): [1, 2, 3]
```

As you can see file and line numbering of where the `log()` function is called appears in the log message which can be quite helpful
for debugging.

### Custom loggers

#### Implementing your own transform

Perhaps the default transformation, `DefaultTransform`, may not be what you want. Maybe you want the module name included in the logged
messages or perhaps don't want the date-and-timestamp included at all. All of this can be up to you if you choose to implement your own
message transform.

You will need to start off with a class that inherits from the `MessageTransform` class and then which overrides the `transform` method as shown below:

```d
import dlog;

public class CustomTranform : MessageTransform
{
	public override string transform(string text, string[] context)
	{
		string transformed;

		/* Insert code to transform `text` and return the `transformed` text */

		return transformed;
	}
}
```

Additional information, besides the text being logged itself (this is the `string text` argument), comes in the form of a string array as `string[] context`
the contents of which are described below:

1. `context[0]`
    * This contains `__FILE_FULL_PATH__` which is the full path (absolute) to the source file where `log()` was called
2. `context[1]`
    * This contains `__FILE__` which is the path (starting at `source/` to the source file where `log()` was called
3. `context[2]`
    * This contains a stringified version of `__LINE__` which is the line number of the call to `log()`
4. `context[3]`
    * This contains `__MODULE__` which is the name of the module the call to `log()` appeared in
5. `context[4]`
    * This contains `__FUNCTION__` which is the name of the function `log()` was called in
6. `context[5]`
    * This contains `__PRETTY_FUNCTION__` which is the same as above but with type information
7. `context[5..X]`
    * This contains optional extras that were set when the `log()` function was called with the `contextExtras` set
    * Example: `log("Hello world", contextExtras=[this])`

#### Creating a Logger

We now need to create a logger that makes use of our message transform, we can do so by creating an instance
of the `Logger` class and passing in our `MessageTransform` as so:

```d
Logger customLogger = new DefaultLogger(new CustomTranform());
```

The above is all one needs to be able to pull off a custom transformation.

#### Custom Logger

Custom loggers can also be created by sub-classing the `Logger` class and overriding the `logImpl(string)` method.
The reason someone may want to do this is up to them. One easy to think of reason is to perhaps applying filtering
of messages to be logged and skip them (as this method is where the I/O of printing out the logs normally happens).
Another reason may be to log to a different data resource, the `DefaultLogger` writes to the file descriptor `0` (stdout),
but you may want to log over a socket connection to a remote machine for example, or perhaps do several pieces of
I/O for your logging. One can do that with a custom logger, you shoudl see `source/dlog/defaults.d` for the implementation
of a custom logger, such as `DefaultLogger`.

## License

LGPLv2
