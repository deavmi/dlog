module dlog.context;

/** 
 * Context that is passed in with the call to log
 */
public class Context
{
    private CompilationInfo lineInfo;

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
}

/**
 * Information obtained during compilation time (if any)
 */
public struct CompilationInfo
{
    private string fullFilePath;
    private string file;
    private ulong line;
    private string moduleName;
    private string functionName;
    private string prettyFunctionName;

    this(string fullFilePath, string file, ulong line, string moduleName, string functionName, string prettyFunctionName)
    {
        this.fullFilePath = fullFilePath;
        this.file = file;
        this.line = line;
        this.moduleName = moduleName;
        this.functionName = functionName;
        this.prettyFunctionName = prettyFunctionName;
    }
}

