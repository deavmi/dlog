/** 
 * Defines some basic message
 * types, filters and handlers
 * that may be of use in
 * some combination or
 * seperate
 *
 * Authors: Tristan Brice Velloza Kildaire (deavmi)
 */
module dlog.basic;

import dlog.core;
import std.stdio : File;

/** 
 * Represents a basic message
 * with log level information
 * associated with it as well
 * as text
 */
public class BasicMessage : Message
{
    /** 
     * The text message
     */
    private string text;

    /** 
     * Log level
     */
    private Level level;

    /** 
     * Constructs a new `BasicMessage`
     * with the given text and log level
     *
     * Params:
     *   text = the message text
     *   level = the log level (default
     * is `Level.INFO`)
     */
    this(string text, Level level = Level.INFO)
    {
        this.text = text;
        this.level = level;
    }

    /** 
     * Constructs an empty message
     * with the highest log level
     * (least verbose)
     */
    this()
    {

    }

    /** 
     * Sets the text
     *
     * Params:
     *   text = the message's
     * text
     */
    public void setText(string text)
    {
        this.text = text;
    }

    /** 
     * Returns the text
     *
     * Returns: the text
     */
    public string getText()
    {
        return this.text;
    }

    /** 
     * Returns the log level
     *
     * Returns: the level
     */
    public Level getLevel()
    {
        return this.level;
    }

    /** 
     * Sets the log level
     *
     * Params:
     *   level = the level
     */
    public void setLevel(Level level)
    {
        this.level = level;
    }
}

/** 
 * A file-based handler which
 * writes `BasicMessage`(s)
 * to a provided file
 */
public class FileHandler : Handler
{
    /** 
     * File to write to
     */
    private File file;

    /** 
     * Constrtucts a new
     * `FileHandler` with
     * the given file
     *
     * Params:
     *   file = the file
     */
    this(File file)
    {
        this.file = file;
    }

    /** 
     * Handles the message, does a
     * no-op if the message is
     * not a kind-of `BasicMessage`
     *
     * Params:
     *   message = the message
     */
    public void handle(Message message)
    {
        // Only handle BasicMessage(s)
        BasicMessage bmesg = cast(BasicMessage)message;
        if(bmesg)
        {
            file.write(bmesg.getText());
        }
    }
}

/** 
 * Logging level
 */
public enum Level
{
    /** 
     * Error message
     */
    ERROR,

    /** 
     * Informative message
     */
    INFO,

    /** 
     * Warning message
     */
    WARN,

    /** 
     * Debugging message
     */
    DEBUG
}

/** 
 * A level-based filter which
 * has a predicate which operates
 * on the value of a pointed-to
 * `Level` variable
 */
private class LevelFilter : Filter
{
    /** 
     * Address of the level var
     */
    private Level* level;

    /** 
     * Constructs a new `LevelFilter`
     * with the given `Level*`
     *
     * Params:
     *   level = the level address
     */
    this(Level* level)
    {
        this.level = level;
    }

    /** 
     * Filters the given message according
     * to the current level. This will no-op
     * and always return `true` if the message
     * is not a kind-of `BasicMessage`
     *
     * Params:
     *   message = the message
     * Returns: the verdict
     */
    public bool filter(Message message)
    {
        // Only handle BasicMessage(s)
        BasicMessage bmesg = cast(BasicMessage)message;
        if(bmesg)
        {
            return bmesg.getLevel() <= *this.level;
        }

        return true;
    }
}

public class BasicLogger : Logger
{
    private Level level;

    this()
    {
        // Attach a new level-filter
        // with access to our current
        // level
        addFilter(new LevelFilter(&level));
    }

    public final void setLevel(Level level)
    {
        this.level = level;
    }

    public final Level getLevel()
    {
        return this.level;
    }
}