package funkin.backend.modding.script.hscript;

#if HSCRIPT_ALLOWED
import crowplexus.iris.Iris;
import crowplexus.iris.IrisConfig;
import crowplexus.hscript.Expr.Error as IrisError;
import crowplexus.hscript.Printer;
#end
import extensions.InterpEx;

@:access(crowplexus.iris.Iris)
class HorizonIris extends Iris
{
  /**
   * List of all accepted hscript extensions
   */
  public static final H_EXTS:Array<String> = ["hx", "hxs", "hscript", "hxc"];

  public static function getPath(path:String)
  {
    for (extension in H_EXTS)
    {
      if (path.endsWith(extension)) return path;

      final file = '$path.$extension';

      final targetPath = Paths.getPath(file, TEXT, null, true);
      if (FunkinAssets.exists(targetPath)) return targetPath;
    }
    return path;
  }
}
