Quick start
===========

### Adding the dependency

We recommend you use [dub](http://code.dlang.org) to add dlog to your project as follows:

```
dub add dlog
```

### Start logging

If you want to immediately begin logging text using the defaults and don't care about implementing your own transformations then you can 
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

You can see the [full API](https://dlog.dpldocs.info/) for more information.