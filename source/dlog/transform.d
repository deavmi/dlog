module dlog.transform;

/**
* MessageTransform
*
* A message transform takes in text, applies
* a transformation to it and outputs said text
*
* Transforms may be chained
*/
public abstract class MessageTransform
{
	/* Next transformation (if any) */
	private MessageTransform chainedTransform;

	/**
	* The actual textual transformation.
	*
	* This is to be implemented by sub-classes
	*/
	public abstract string transform(string text, string[] context);

	/**
	* Chain a transform
	*/
	public final void chain(MessageTransform transform)
	{
		chainedTransform = transform;
	}

	/**
	* Perform the transformation
	*/
	public final string execute(string text, string[] context)
	{
		/* Perform the transformation */
		string transformedText = transform(text, context);

		/* If there is a chained transformation */
		if(chainedTransform)
		{
			transformedText = chainedTransform.execute(transformedText, context);
		}

		return transformedText;
	}
}