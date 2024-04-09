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

public class FileHandler : Handler
{
    
    private File file;
    this(File file)
    {
        this.file = file;
    }

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

private class LevelFilter : Filter
{
    private Level* level;

    this(Level* level)
    {
        this.level = level;
    }

    public bool filter(Message message)
    {
        // Only handle BasicMessage(s)
        BasicMessage bmesg = cast(BasicMessage)message;
        if(bmesg)
        {
            return bmesg.getLevel() <= *this.level;
        }

        return false;
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

public class ConsoleLogger : BasicLogger
{
    this()
    {
        import std.stdio;
        addHandler(new FileHandler(stdout));
    }
}