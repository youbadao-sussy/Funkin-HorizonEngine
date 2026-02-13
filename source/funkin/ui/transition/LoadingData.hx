package source.funkin.ui.transition;

/**
 * MenuTrans 1
 */
typedef MenuTransData =
{
  var transOut:DefaultTransInOutData;
  var transIn:DefaultTransInOutData;
}

/**
 * MenuTrans 2
 */
typedef DefaultTransInOutData =
{
  var type:String; // Original, Funkin' Legacy, Square, Circle, Diamond, Sticker, None, Custom
  var color:String;
  var direction:String; // N, S, E, W, NE, NW, SE, SW
  var duration:Float;
  @:optional @:default(false) var loadingImage:Bool;
  @:optional @:default(false) var randomImage:Bool;
  @:optional var assetPath:Array<String>;
}

/**
 * FreeplayTrans 1
 */
typedef FreeplayTransData =
{
  var transOut:DefaultTransInOutData;
  var transIn:Array<FreeplayTransInData>;
}

/**
 * FreeplayTrans 2
 */
typedef FreeplayTransInData =
{
  var songName:String;
  var type:String; // Original, Funkin' Legacy, Square, Circle, Diamond, Sticker, None, Custom
  var color:String;
  var direction:String; // N, S, E, W, NE, NW, SE, SW
  var duration:Float;
  @:optional @:default(false) var loadingImage:Bool;
  @:optional @:default(false) var randomImage:Bool;
  @:optional var assetPath:Array<String>;
}

/**
 * PlayStateTrans 1
 */
typedef PlayStateTransData =
{
  var transOut:DefaultTransInOutData;
  var transIn:DefaultTransInOutData;
  var transInResult:DefaultTransInOutData;
}
