package source.funkin.backend.song;

import funkin.graphics.shaders.AdjustColorShader;
import thx.semver.Version;

class SongMetaData
{
  public var version:Version;
  // public var title:String = "Unknown";
  // public var data:String = "unknown";
  public var songName:String = "Unknown";
  public var artist:String = "Unknown";
  public var charter:String = "Unknown";
  public var bpm:Float = 150;
  public var playData:SongPlayData;
}

class SongPlayData
{
  @:optional public var variation:Array<String> = [""];
  public var difficulties:Array<String> = ["Normal"];
  public var characters:SongCharaDeta;
  public var stages:String;
  public var noteStyle:String = "funkin";
}

class SongCharaDeta
{
  // public var opponent:Map<String, AdjustColorShader>;
  // public var center:Map<String, AdjustColorShader>;
  // public var player:Map<String, AdjustColorShader>;
  @:optional public var opponent:String = "";
  @:optional public var center:String = "";
  @:optional public var player:String = "";
  @:optional public var instrumental:String = "";
  @:optional public var altInstrumental:Array<String> = null;
  @:optional public var opponentVocals:Null<Array<String>> = null;
  @:optional public var playerVocals:Null<Array<String>> = null;
}

class SongOffsetData
{
  public var opponent:Float;
  public var player:Float;
  public var instrumental:Float = 0;
  public var altInstrumental:Map<String, Float>;
}

class SongChartData
{
  public var version:Version;
  public var scrollSpeeds:Map<String, Float>;
  public var events:Array<Dynamic>;
  public var notes:Map<String, Array<SongNoteData>>;
}

class SongHealthData
{
  public var healthGain:Float = 0;
  public var healthLoss:Float = 0;
}

class SongNoteData
{
  @:alias("t") public var time(default, set):Float;
  @:alias("d") public var data:Int;
  @:alias("l") public var length:Float = 0;
  @:alias("k") @:optional @:isVar public var kind(get, set):Null<String>;
  @:alias("k") @:default([]) @:optional public var params:Array<NoteParamData>;
}

class NoteParamData
{
  @:alias("n")
  public var name:String;

  @:alias("v")
  // @:jcustomparse(funkin.data.DataParse.dynamicValue)
  // @:jcustomwrite(funkin.data.DataWrite.dynamicValue)
  public var value:Dynamic;
  /*
    public function new(name:String, value:Dynamic)
    {
      this.name = name;
      this.value = value;
    }

    public function clone():NoteParamData
    {
      return new NoteParamData(this.name, this.value);
    }

    public function toString():String
    {
      return 'NoteParamData(${this.name}, ${this.value})';
    }
   */
}
