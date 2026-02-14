package funkin.objects;

import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxSort;
import flixel.util.FlxDestroyUtil;
import openfl.utils.AssetType;
import openfl.utils.Assets;
import haxe.Json;
import funkin.backend.animation.AnimController;

// import backend.Song;
using StringTools;

typedef CharacterFile =
{
  var name:String;
  var renderType:CharacterRenderType;
  var animations:Array<AnimationData>;
  var image:String;
  var scale:Float;
  var singTime:Null<Float>;
  var healthicon:Array<IconData>;

  var offsets:Array<Float>;
  var cameraOffsets:Array<Float>;

  var flipX:Bool;
  var no_antialiasing:Bool;
  var isPixel:Bool;
}

typedef AnimationData =
{
  var assetPath:String;
  var name:String;
  var prefix:String;
  var fps:Int;
  var looped:Bool;
  var indices:Array<Int>;
  var offsets:Array<Int>;
}

typedef IconData =
{
  var id:String;
  var scale:Int;
  var flipX:Bool;
  var isPixel:Bool;
  var offsets:Array<Int>;
}

enum abstract CharacterRenderType(String) from String to String
{
  /**
   * Renders the character using a single spritesheet and XML data.
   */
  public var Sparrow = 'sparrow';

  /**
   * Renders the character using a single spritesheet and TXT data.
   */
  public var Packer = 'packer';

  /**
   * Renders the character using multiple spritesheets and XML data.
   */
  public var MultiSparrow = 'multisparrow';

  /**
   * Renders the character using a single spritesheet of symbols and JSON data.
   */
  public var AnimateAtlas = 'animateatlas';

  /**
   * Renders the character using multiple spritesheets of symbols and JSON data.
   */
  public var MultiAnimateAtlas = 'multianimateatlas';

  /**
   * Renders the character using a custom method.
   */
  public var Custom = 'custom';
}

/**
 * Character object class
 */
class Character extends FlxSprite
{
  public static final DEFAULT_CHARACTER:String = 'bf';
  public static final DEFAULT_RENDERTYPE:CharacterRenderType = CharacterRenderType.Sparrow;

  public var animOffsets:Map<String, Array<Dynamic>>;
  public var animData:Map<String, Array<AnimationData>>;

  public function new(x:Float, y:Float, jsonPath:String, ?isPlayer:Bool = false, ?renderType:CharacterRenderType = CharacterRenderType.Sparrow)
  {
    super(x, y);
    animOffsets = new Map<String, Array<Dynamic>>();
    animData = new Map<String, Array<AnimationData>>();
    this.isPlayer = isPlayer;
    var data:CharacterFile = Json.parse(Assets.getText(jsonPath));
    switch (data.renderType)
    {
      case CharacterRenderType.Sparrow: // loadSparrow(data);
        frames = FlxAtlasFrames.fromSparrow(data.image, data.image);
        /*
          case CharacterRenderType.Packer:
            loadPacker(data);
          case CharacterRenderType.MultiSparrow:
            loadMultiSparrow(data);
          case CharacterRenderType.AnimateAtlas:
            loadAnimateAtlas(data);
          case CharacterRenderType.MultiAnimateAtlas:
            loadMultiAnimateAtlas(data);
          case CharacterRenderType.Custom:
            loadCustom(data);
         */
    }
    for (anim in data.animations)
    {
      animation.addByPrefix(anim.name, anim.prefix, anim.fps, anim.looped);
      if (anim.offsets != null && anim.offsets.length > 1) addOffset(anim.name, anim.offsets[0], anim.offsets[1]);
      else
        addOffset(anim.name, 0, 0);
    }
    playAnim("idle");
  }

  var currentPriority:Int = 0;

  public function playAnim(name:String)
  {
    var data = animData[name];
    if (data.priority < currentPriority) return;
    animation.play(name);
    currentPriority = data.priority;
    if (!animation.curAnim.looped && animation.finished)
    {
      playAnim("idle");
      currentPriority = 0;
    }
  }

  public function addOffset(name:String, x:Float = 0, y:Float = 0)
  {
    animOffsets[name] = [x, y];
  }
}
