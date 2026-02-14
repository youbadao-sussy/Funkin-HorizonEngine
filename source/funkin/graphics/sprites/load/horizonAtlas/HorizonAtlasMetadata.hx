package funkin.graphics.sprites.load.horizonAtlas;

typedef Metadata =
{
  @:alias("TYPE") var type:String;
  @:alias("SPRITE") var sprites:Array<SpriteMapData>;
  @:alias("META") var meta:ExportInfo;
}

typedef SpriteMapData =
{
  @:alias("S") var sprite:SpriteData;
  @:alias("V") var vertex:VertexData;
}

typedef SpriteData =
{
  @:alias("N") var name:String;
  @:alias("X") var x:Float;
  @:alias("Y") var y:Float;
  @:alias("W") var width:Float;
  @:alias("H") var height:Float;
  @:alias("R") @:default(false) var rotated:Bool;
}

typedef VertexData =
{
  @:alias("A") var axis:Array<Float>;
  @:alias("D") var deform:Array<Float>;
}

typedef ExportInfo =
{
  var generatedBy:String;
  var version:String;
  var image:String;
  var size:Array<Int>;
}
