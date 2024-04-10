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
    
[![D](https://github.com/deavmi/dlog/actions/workflows/d.yml/badge.svg)](https://github.com/deavmi/dlog/actions/workflows/d.yml)

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
	* The _base logger_ (i.e. `Logger`) maintains a list of attaches _filters_, _message transformers_ and _handlers_
2. `Filter`
	* Acts as a predicate on the incoming _message_ and determines whether it should be logged or not
	* This is used by the `BasicLogger` to implement log levels
3. `Transform`
	* A _message transform_ is attached to a logger and performs manipulation on the message logged
	* They may be chained as to perform multiple transformations in a stream-like fashion
4. `Handler`
	* A _handler_ handles the final transformed message, for some this means outputting to standard out, or a file

### Quick start

If you want to immediately begin logging text usin the defaults and don't care about implementing your own transformations then you can 
simply use the default logger as follows:

```d
import dlog;

DefaultLogger logger = new DefaultLogger();

logger.setLevel(Level.DEBUG);
logger.error(["woah", "LEVELS!"], 69.420);
logger.info(["woah", "LEVELS!"], 69.420);
logger.warn(["woah", "LEVELS!"], 69.420);
logger.debug_(["woah", "LEVELS!"], 69.420);

// Should not be able to see this
logger.setLevel(Level.INFO);
logger.debug_("Can't see me!");
```

This will output the following:

```
[2024-Apr-09 19:14:38.3077171]  (ERROR): ["woah", "LEVELS!"] 69.42
[2024-Apr-09 19:14:38.3077346]  (INFO): ["woah", "LEVELS!"] 69.42
[2024-Apr-09 19:14:38.3077559]  (WARN): ["woah", "LEVELS!"] 69.42
[2024-Apr-09 19:14:38.3077759]  (DEBUG): ["woah", "LEVELS!"] 69.42
```

You can see the [full API](https://dlog.dpldocs.info/v0.3.19/dlog.context.html) for more information.

### Custom loggers

#### Implementing your own transform

Perhaps the default transformation, `DefaultTransform`, may not be what you want. Maybe you want the module name included in the logged
messages or perhaps don't want the date-and-timestamp included at all. All of this can be up to you if you choose to implement your own
message transform.

You will need to start off with a class that inherits from the `Transform` class and then which overrides the `transform` method as shown below:

```d
import dlog;

public class CustomTranform : Transform
{
	public override Message transform(Message message)
	{
		BasicMessage bmesg = cast(BasicMessage)message;
		
		// Only handle BasicMessage(s) - ones which have `setText(string)`
		if(bmesg is null)
		{
			return message;
		}

		string transformed;
		/* Insert transformation code here */
		bmesg.setText(transformed);

		return message;
	}
}
```

## License

LGPL v3
