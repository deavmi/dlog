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
