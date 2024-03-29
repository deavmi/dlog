/** 
 * Context for logging
 */

module dlog.context;

import std.conv : to;

/** 
 * Debugging trace level
 */
public enum Level
{
    /** 
     * Informative message
     */
    INFO,

    /** 
     * Warning message
     */
    WARN,

    /** 
     * Error message
     */
    ERROR,

    /** 
     * Debugging message
     */
    DEBUG
}

/** 
 * Context that is passed in with the call to log
 */
public class Context
{
    private CompilationInfo lineInfo;
    private Level level;

    /** 
     * Constructs a new Context
     */
    this()
    {

    }

    /** 
     * Set the line information
     *
     * Params:
     *   lineInfo = the CompilationInfo struct to use
     */
    public final void setLineInfo(CompilationInfo lineInfo)
    {
        this.lineInfo = lineInfo;
    }

    /** 
     * Obtain the line information generated at compilation
     * time
     *
     * Returns: the CompilationInfo struct
     */
    public final CompilationInfo getLineInfo()
    {
        return lineInfo;
    }

    /** 
     * Returns the current tarce level
     *
     * Returns: the Level
     */
    public final Level getLevel()
    {
        return level;
    }

    /** 
     * Set the trace level
     *
     * Params:
     *   level = the Level to use
     */
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
    /**
     * compile time usage file
     */
    public string fullFilePath;

    /** 
     * compile time usage file (relative)
     */
    public string file;

    /** 
     * compile time usage line number
     */
    public ulong line;

    /** 
     * compile time usage module
     */
    public string moduleName;

    /** 
     * compile time usage function
     */
    public string functionName;

    /**
     * compile time usage function (pretty)
     */
    public string prettyFunctionName;

    /** 
     * Constructs the compilation information with the provided
     * parameters
     *
     * Params:
     *   __FILE_FULL_PATH__ = compile time usage file
	 *   __FILE__ = compile time usage file (relative)
	 *   __LINE__ = compile time usage line number
	 *   __MODULE__ = compile time usage module
	 *   __FUNCTION__ = compile time usage function
	 *   __PRETTY_FUNCTION__ = compile time usage function (pretty)
     */
    this(string fullFilePath, string file, ulong line, string moduleName, string functionName, string prettyFunctionName)
    {
        this.fullFilePath = fullFilePath;
        this.file = file;
        this.line = line;
        this.moduleName = moduleName;
        this.functionName = functionName;
        this.prettyFunctionName = prettyFunctionName;
    }

    /** 
     * Flattens the known compile-time information into a string array
     *
     * Returns: a string[]
     */
    public string[] toArray()
    {
        return [fullFilePath, file, to!(string)(line), moduleName, functionName, prettyFunctionName];
    }
}