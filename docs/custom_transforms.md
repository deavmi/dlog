Custom transforms
=================

## Implementing your own transform

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
