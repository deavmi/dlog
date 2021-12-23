dlog
====

**Simple and modular logging library**

<center>
`[2021-Dec-23 11:17:35.3527637]	(source/dlog/testing/thing.d:12): This is a log message`
</center>

---

## Usage

We recommend you use [dub](http://code.dlang.org) to add dlog to your project as follows:

```
dub add dlog
```

### Components

dlog is formed out of two main components:

1. `Logger`
	* The logger contains the needed barebones for facilitating the actual logging of text
2. `MessageTransform`
	* A MessageTransform is attached to a logger and performs manipulation on the text input into the logger for logging
	* They may be chained as to perform multiple transformations in a stream-like fashion

### Quick start

If you want to immediately begin logging text usin the defaults and don't care about implementing your own transformations then you can 
simply use the defaulkt logger as follows:

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

		

		return transformed;
	}
}
```

Additional information, besides the text being logged itself (this is the `string text` argument), comes in the form of a string array as `string[] context`
the contents of which are described below:

1. `context[0]`
TODO

## License

LGPLv2