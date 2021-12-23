module dlog.testing.thing;

import dlog;

/**
* Tests the DefaultLogger
*/
unittest
{
	Logger logger = new DefaultLogger();

	logger.log("This is a log message");
	logger.log(1);
	logger.log(true);
	logger.log([1,2,3]);
}
