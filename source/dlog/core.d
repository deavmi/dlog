/** 
 * Core logging services
 *
 * Authors: Tristan Brice Velloza Kildaire (deavmi)
 */
module dlog.core;

import std.container.slist : SList;
import core.sync.mutex : Mutex;

/** 
 * The base message type
 */
public abstract class Message
{

}

/** 
 * Defines the filtering
 * interface
 */
public interface Filter
{
    /** 
     * Filters the given message
     * returning a verdict
     * based on it
     *
     * Params:
     *   message = the message
     * Returns: the verdct
     */
    public bool filter(Message message);
}

/** 
 * Defines the message
 * transformation interface
 */
public interface Transform
{
    /** 
     * Transforms the given message
     *
     * Params:
     *   message = the message input
     * Returns: the transformed
     * message
     */
    public Message transform(Message message);
}

/** 
 * Defines the interface
 * for handling messages
 */
public interface Handler
{
    /** 
     * Handles the given message
     *
     * Params:
     *   message = the message to
     * handle
     */
    public void handle(Message message);
}

/** 
 * Defines the base logger
 * and functionality associated
 * with it
 */
public abstract class Logger
{
    private SList!(Transform) transforms;
    private SList!(Filter) filters;
    private SList!(Handler) handlers;
    private Mutex lock; // Lock for attached handlers, filters and transforms

    /** 
     * Constructs a new logger
     */
    this()
    {
        this.lock = new Mutex();
    }

    // TODO: Handle duplicate?
    /** 
     * Adds the given transform
     *
     * Params:
     *   transform = the transform
     * to add
     */
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
    /** 
     * Removes the given transform
     *
     * Params:
     *   transform = the transform
     * to remove
     */
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

    /** 
     * Adds the given filter
     *
     * Params:
     *   filter = the filter
     * to add
     */
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

    /** 
     * Removes the given filter
     *
     * Params:
     *   filter = the filter
     * to remove
     */
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

    /** 
     * Adds the given handler
     *
     * Params:
     *   handler = the handler
     * to add
     */
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

    /** 
     * Removes the given handler
     *
     * Params:
     *   handler = the handler
     * to remove
     */
    public final void removeHandler(Handler handler)
    {
        scope(exit)
        {
            this.lock.unlock();
        }

        this.lock.lock();

        this.handlers.linearRemoveElement(handler);
    }

    /** 
     * Logs the provided message by processing
     * it through all the filters, and if
     * the verdict is `true` then transforms
     * the message via all transformers
     * and finally dispatches said message
     * to all attached handlers
     *
     * Params:
     *   message = the message
     */
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