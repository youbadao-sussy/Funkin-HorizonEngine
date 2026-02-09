package source.funkin.backend.animation.cutscenes;

class CutscenesMetaData
{
  public var name:String = "Your Cutscenes";
  public var artist:String = "Unknown";
  public var author:String = "Unknown";
  public var framerate:Float = 30;
  public var assetsFolderPath:String;
  public var characters:Array<CutsceneCharacterData>;
  public var seen:Array<CutsceneData>;
}

class CutsceneData
{
  public var name:String = "Start";
  public var frame:String = "0";
  public var animation:Map<String, CutscenesAnimationData>;
}

class CutscenesAnimationData
{
  @:alias("ps") public var offsets:Array<Int> = [0, 0];
  @:alias("an") public var animation:AnimationPartsData;
}

class AnimationPartsData
{
  public var name:String = "idle";
  public var framerate:Int = 24;
  @:optional public var indices:Array<Int>;
}

class CutsceneCharacterData
{
  public var name:String = "Your Character";
  public var assets:Array<CutscenesCharPartsData>;
}

class CutscenesCharPartsData
{
  public var name:String = "Body";
  public var assetPath:String;
  @:optional public var assetType:String = "Parts"; // Parts or Sparrow File
  @:optional public var include:Array<String>;
  @:optional public var offsets:Array<Int> = [0, 0];
  @:optional public var angle:Int = 0;
  @:optional public var scale:Float = 1.0;
  public var parentSettings:Array<Dynamic> = [false, "Null"];
}
