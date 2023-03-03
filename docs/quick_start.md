Quick start
===========

### Adding the dependency

We recommend you use [dub](http://code.dlang.org) to add dlog to your project as follows:

```
dub add dlog
```

### Start logging

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

You can also look into `logc(Context, string)` which allows you to use a `Context` object when logging, more information available in the [full API](https://dlog.dpldocs.info/v0.3.8/dlog.context.html).