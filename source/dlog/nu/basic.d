module dlog.nu.basic;

import dlog.nu.core;

public class BasicMessage : Message
{
    private string text;
    private Level level;

    this(string text, Level level = Level.INFO)
    {
        this.text = text;
        this.level = level;
    }

    public string getText()
    {
        return this.text;
    }

    public Level getLevel()
    {
        return this.level;
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
            file.writeln(bmesg.getText());
        }
    }
}

public enum Level
{
    ERROR,
    WARNING,
    INFO,
    DEBUG
}

public class LevelFilter : Filter
{
    private Level curLevel;

    this()
    {

    }

    public bool filter(Message message)
    {
        // Only handle BasicMessage(s)
        BasicMessage bmesg = cast(BasicMessage)message;
        if(bmesg)
        {
            return bmesg.getLevel() <= this.curLevel;
        }

        return false;
    }
}

public class BasicLogger : Logger
{
    private Level level;

    this()
    {

    }
}