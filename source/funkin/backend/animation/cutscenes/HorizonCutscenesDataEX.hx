package source.funkin.backend.animation.cutscenes;

class CutscenesDataMain
{
  public var name:String = "Your Cutscenes";
  public var artist:String = "Unknown";
  public var author:String = "Unknown";
  public var framerate:Float = 30;
  public var assetsFolderPath:String;
  public var characters:Array<CutsceneCharacterData>;
  public var seen:Array<CutsceneData>;
}

class CutsceneCharacterData
{
  public var name:String = "Character";
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
