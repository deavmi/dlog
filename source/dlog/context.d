module dlog.context;

import std.conv : to;


public enum Level
{
    INFO,
    WARN,
    ERROR,
    DEBUG
}

/** 
 * Context that is passed in with the call to log
 */
public class Context
{
    private CompilationInfo lineInfo;
    private Level level;

    this()
    {

    }

    public final void setLineInfo(CompilationInfo lineInfo)
    {
        this.lineInfo = lineInfo;
    }

    public final CompilationInfo getLineInfo()
    {
        return lineInfo;
    }

    public final Level getLevel()
    {
        return level;
    }

    public final void setLevel(Level level)
    {
        this.level = level;
    }
}

/**
 * Information obtained during compilation time (if any)
 */
public struct CompilationInfo
{
    public string fullFilePath;
    public string file;
    public ulong line;
    public string moduleName;
    public string functionName;
    public string prettyFunctionName;

    this(string fullFilePath, string file, ulong line, string moduleName, string functionName, string prettyFunctionName)
    {
        this.fullFilePath = fullFilePath;
        this.file = file;
        this.line = line;
        this.moduleName = moduleName;
        this.functionName = functionName;
        this.prettyFunctionName = prettyFunctionName;
    }

    public string[] toArray()
    {
        return [fullFilePath, file, to!(string)(line), moduleName, functionName, prettyFunctionName];
    }

}

