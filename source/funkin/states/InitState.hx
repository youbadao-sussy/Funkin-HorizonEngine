package funkin.states;

class InitState extends FlxState
{
  public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
  public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
  public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

  public static var initialized:Bool = false;

  var credGroup:FlxGroup = new FlxGroup();
  var textGroup:FlxGroup = new FlxGroup();
  var blackScreen:FlxSprite;
  var ngSpr:FlxSprite;

  var titleTextColors:Array<FlxColor> = [0xFF33FFFF, 0xFF3333CC];
  var titleTextAlphas:Array<Float> = [1, .64];

  var curWacky:Array<String> = [];

  var wackyImage:FlxSprite;

  override function create():Void
  {
    super.create();
  }
}
