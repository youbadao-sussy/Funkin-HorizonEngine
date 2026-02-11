package funkin.backend.song;

import thx.semver.Version;

class FreeplayMetaData
{
  public var version:String;
  @:optional public var transInStyle:String = "V-Slice";
  @:optional public var characterSelect:Bool = true;
  @:optional public var inPlayableChar:Array<String> = ["Boyfriend", "Pico"];
  public var categories:Array<FreeplayPlayableCategory>;
}

class FreeplayPlayableCategory
{
  public var playCharName:String = "Boyfriend";
  public var inDiffs:Array<String> = ["normal"];
}

class FreeplayMainData
{
  public var Version:Version;
  public var name:String = "Unknown Section";
  @:optional public var variation:String = "";
  public var difficulty:String = "Normal";
  public var randomSelect:Bool = true;
  public var bgAssets:BGAssetsData;
  public var songs:Array<FreeplaySongData>;
}

class BGAssetsData
{
  public var backBG:String;
  public var charBG:String;
  public var songBG:String;
  public var ostArt:Bool = true;
  @:optional public var ostArtFile:String = "";
  @:optional public var setOstTextFont:Bool = false;
  @:optional public var ostTextAsset:String = "";
  @:optional public var characterAsset:String = "";
}

class FreeplaySongData
{
  public var title:String; // Song titles, yeah its Song Name
  public var ratings:Int = 0;
  @:optional public var ostArt:String;
  @:optional public var ostText:String;
  @:optional public var ostTextFont:String;
  @:optional public var ostAsset:String;
}
