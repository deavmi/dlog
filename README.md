<p align="center">
<img src="branding/logo.png" width=220>
</p>

<br>

<h1 align="center">dlog</h1>

<h3 align="center"><i><b>Simple and modular logging library</i></b></h3>

---

<br>
<br


`[2021-Dec-23 11:17:35.3527637]	(source/dlog/testing/thing.d:12): This is a log message`

---

## Usage

We recommend you use [dub](http://code.dlang.org) to add dlog to your project as follows:

```
dub add dlog
```

* [View on DUB](https://code.dlang.org/packages/dlog)
* [View API](https://dlog.dpldocs.info/v0.3.19/index.html)

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

---

We also support many different logging levels which can be accomplished using the `error`, `debug_` (or the `dbg` alias), `info `(the default) and `warn`:

```d
Logger logger = new DefaultLogger();

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
```

This outputs the following:

```
[2023-Mar-03 11:33:49.2617904]	(source/dlog/core.d:427): ["woah", "LEVELS!"] 69.42
[2023-Mar-03 11:33:49.2618091]	(source/dlog/core.d:430): ["woah", "LEVELS!"] 69.42
[2023-Mar-03 11:33:49.2618273]	(source/dlog/core.d:433): ["woah", "LEVELS!"] 69.42
[2023-Mar-03 11:33:49.2618457]	(source/dlog/core.d:436): ["woah", "LEVELS!"] 69.42
```

You can also look into `logc(Context, string)` which allows you to use a `Context` object when logging, more information available in the [full API](https://dlog.dpldocs.info/v0.3.19/dlog.context.html).

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
	public override string transform(string text, Context context)
	{
		string transformed;

		/* Insert code to transform `text` and return the `transformed` text */

		return transformed;
	}
}
```

Additional information, besides the text being logged itself (this is the `string text` argument), comes in the form of a `Context` object `context`. What one can get from this is a `CompilationInfo` struct which contains the following fields below if one calls `toArray()` on
it which will return a string array shown below (we refer to this array as `lineInfo`):

1. `lineInfo[0]`
    * This contains `__FILE_FULL_PATH__` which is the full path (absolute) to the source file where `log()` was called
2. `lineInfo[1]`
    * This contains `__FILE__` which is the path (starting at `source/` to the source file where `log()` was called
3. `lineInfo[2]`
    * This contains a stringified version of `__LINE__` which is the line number of the call to `log()`
4. `lineInfo[3]`
    * This contains `__MODULE__` which is the name of the module the call to `log()` appeared in
5. `lineInfo[4]`
    * This contains `__FUNCTION__` which is the name of the function `log()` was called in
6. `lineInfo[5]`
    * This contains `__PRETTY_FUNCTION__` which is the same as above but with type information

The point of a `Context` object is also such that a custom transformer may expect a kind-of `Context` like a custom one (i.e. `CustomContext`)
which perhaps a custom logger (kind-of `Logger`) can then have set certain fields in it.

## Creating a Logger

We now need to create a logger that makes use of our message transform, we can do so by creating an instance
of the `Logger` class and passing in our `MessageTransform` as so:

```d
Logger customLogger = new DefaultLogger(new CustomTranform());
```

The above is all one needs to be able to pull off a custom transformation.

### Custom Logger

Custom loggers can also be created by sub-classing the `Logger` class and overriding the `logImpl(string)` method.
The reason someone may want to do this is up to them. One easy to think of reason is to perhaps applying filtering
of messages to be logged and skip them (as this method is where the I/O of printing out the logs normally happens).
Another reason may be to log to a different data resource, the `DefaultLogger` writes to the file descriptor `0` (stdout),
but you may want to log over a socket connection to a remote machine for example, or perhaps do several pieces of
I/O for your logging. One can do that with a custom logger, you shoudl see `source/dlog/defaults.d` for the implementation
of a custom logger, such as `DefaultLogger`.

## License

LGPL v3