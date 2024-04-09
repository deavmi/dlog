module dlog.nu.core;

public class Message
{

}

public interface Filter
{
    public bool filter(Message message);
}

public interface MessageTransform
{
    public Message transform(Message message);
}

public interface Handler
{
    public void handle(Message message);
}

import std.container.slist : SList;
// import std.range : in;
import core.sync.mutex : Mutex;

public abstract class Logger
{
    private SList!(MessageTransform) transforms;
    private SList!(Filter) filters;
    private SList!(Handler) handlers;
    private Mutex lock; // Lock for attached handlers, filters and transforms

    this()
    {
        this.lock = new Mutex();
    }
}