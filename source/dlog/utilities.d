/** 
 * Helper functions
 *
 * Authors: Tristan Brice Velloza Kildaire (deavmi)
 */
module dlog.utilities;

import std.conv : to;

/** 
 * Given an arbitrary amount of arguments, convert each to a string
 * and return that as an array
 *
 * Params:
 *   segments = alias sequence
 * Returns: a flattened string[]
 */
public string[] flatten(TextType...)(TextType segments)
{
    /* The flattened components */
    string[] components;

    /* Flatten the components */
    static foreach(messageComponent; segments)
    {
        components ~= to!(string)(messageComponent);
    }

    return components;
}