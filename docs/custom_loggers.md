Custom loggers
==============

Custom loggers can also be created by sub-classing the `Logger` class and overriding the `logImpl(string)` method.
The reason someone may want to do this is up to them. One easy to think of reason is to perhaps applying filtering
of messages to be logged and skip them (as this method is where the I/O of printing out the logs normally happens).
Another reason may be to log to a different data resource, the `DefaultLogger` writes to the file descriptor `0` (stdout),
but you may want to log over a socket connection to a remote machine for example, or perhaps do several pieces of
I/O for your logging. One can do that with a custom logger, you shoudl see `source/dlog/defaults.d` for the implementation
of a custom logger, such as `DefaultLogger`.
