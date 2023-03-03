dlog
====

**Simple and modular logging library**

## Usage

We recommend you use [dub](http://code.dlang.org) to add dlog to your project as follows:

```
dub add dlog
```

* [View on DUB](https://code.dlang.org/packages/dlog)
* [View API](https://dlog.dpldocs.info/v0.3.19/index.html)

## Components

dlog is formed out of two main components:

1. `Logger`
	* The logger contains the needed barebones for facilitating the actual logging of text
2. `MessageTransform`
	* A MessageTransform is attached to a logger and performs manipulation on the text input into the logger for logging
	* They may be chained as to perform multiple transformations in a stream-like fashion

---

## License

LGPLv3

