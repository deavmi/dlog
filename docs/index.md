dlog
====

**Simple and modular logging library**

## Usage

We recommend you use [dub](http://code.dlang.org) to add dlog to your project as follows:

```
dub add dlog
```

* [View on DUB](https://code.dlang.org/packages/dlog)
* [View API](https://dlog.dpldocs.info/)

## Components

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

---

## License

LGPLv3

