module dlog.core;

public class Message
{

}

public interface Filter
{
    public bool filter(Message message);
}

public interface Transform
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
    private SList!(Transform) transforms;
    private SList!(Filter) filters;
    private SList!(Handler) handlers;
    private Mutex lock; // Lock for attached handlers, filters and transforms

    this()
    {
        this.lock = new Mutex();
    }

    // TODO: Handle duplicate?
    public final void addTransform(Transform transform)
    {
        scope(exit)
        {
            this.lock.unlock();
        }

        this.lock.lock();

        this.transforms.insertAfter(this.transforms[], transform);
    }

    // TODO: Hanmdle not found explicitly?
    public final void removeTransform(Transform transform)
    {
        scope(exit)
        {
            this.lock.unlock();
        }

        this.lock.lock();

        this.transforms.linearRemoveElement(transform);
    }

    // TODO: Handle duplicate?
    public final void addFilter(Filter filter)
    {
        scope(exit)
        {
            this.lock.unlock();
        }

        this.lock.lock();

        this.filters.insertAfter(this.filters[], filter);
    }

    // TODO: Hanmdle not found explicitly?
    public final void removeFilter(Filter filter)
    {
        scope(exit)
        {
            this.lock.unlock();
        }

        this.lock.lock();

        this.filters.linearRemoveElement(filter);
    }

    // TODO: Handle duplicate?
    public final void addHandler(Handler handler)
    {
        scope(exit)
        {
            this.lock.unlock();
        }

        this.lock.lock();

        this.handlers.insertAfter(this.handlers[], handler);
    }

    // TODO: Hanmdle not found explicitly?
    public final void removeHandler(Handler handler)
    {
        scope(exit)
        {
            this.lock.unlock();
        }

        this.lock.lock();

        this.handlers.linearRemoveElement(handler);
    }

    // Logs an actual message
    //
    // This first passes it over all filters
    // then to a transform and then copies
    // to each handler
    public final void log(Message message)
    {
        scope(exit)
        {
            this.lock.unlock();
        }

        this.lock.lock();

        foreach(Filter filter; this.filters)
        {
            if(!filter.filter(message))
            {
                return;
            }
        }

        Message curMessage = message;
        foreach(Transform transform; this.transforms)
        {
            curMessage = transform.transform(curMessage);
        }

        foreach(Handler handler; this.handlers)
        {
            handler.handle(curMessage);
        }
    }
}