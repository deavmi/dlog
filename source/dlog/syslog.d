module dlog.syslog;

import core.sys.posix.syslog : openlog, syslog, closelog;

import dlog.core : Handler, Message;
import dlog.basic : BasicMessage;

/** 
 * A file-based handler which
 * writes `BasicMessage`(s)
 * to a provided file
 */
public class SyslogHandler : Handler
{
    this(string name)
    {
        // TODO: what top set options and facility to?
        openlog(name.ptr, 0, 0);
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
            // TODO: What to set priortiy to?
            syslog(0, bmesg.getText().ptr);
        }
    }

    ~this()
    {
        closelog();
    }
}

unittest
{
    BasicLogger log = new BasicLogger();
    log.addHandler(new SyslogHandler("Ting"));
    log.log(new BasicMessage("Howdy"));

}

version(unittest)
{
    import dlog.basic;
}