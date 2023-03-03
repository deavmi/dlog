Custom transforms
=================

## Implementing your own transform

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
