package source.funkin.backend.json;

class LevelDataMain
{
  public var name:String = "Your New Week";
  @:optional public var setFontTitle:Bool = false;
  public var title:LevelTitle;
  public var backgroundColor:Int;
  public var props:Array<LevelProps>;
  @:optional public var bgArt:String;
}

class LevelTitle
{
  public var text:String = "Week1";
  public var assetPath:String;
  @:optional public var font:String = "vcr";
}

class LevelProps
{
  public var name:String = "Boyfriend";
  @:optional public var playAnimation:Bool = true;
  public var scale:Float = 1.0;
  public var offsets:Array<Float> = [0, 0];
  public var props:Array<PropsAnimation>;
}

class PropsAnimation
{
  public var name:String = "idle";
  public var framerate:Int = 24;
  public var scale:Float = 1.0;
  public var prefix:String;
  @:optional public var indices:Array<Float>;
  @:optional public var offsets:Array<Float> = [0, 0];
}
