module dlog.basic;

import dlog.core;

public class BasicMessage : Message
{
    private string text;
    private Level level;

    this(string text, Level level = Level.INFO)
    {
        this.text = text;
        this.level = level;
    }

    this()
    {

    }

    public void setText(string text)
    {
        this.text = text;
    }

    public string getText()
    {
        return this.text;
    }

    public Level getLevel()
    {
        return this.level;
    }

    public void setLevel(Level level)
    {
        this.level = level;
    }
}

public class Context
{

}

public class FileHandler : Handler
{
    import std.stdio : File;
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