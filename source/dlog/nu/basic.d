module dlog.nu.basic;

import dlog.nu.core;

public class BasicMessage : Message
{
    private string text;
    private Context ctx; 

    public string getText()
    {
        return this.text;
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