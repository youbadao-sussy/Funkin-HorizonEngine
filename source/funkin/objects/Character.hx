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
  public var debugMode:Bool = false;
  public var extraData:Map<String, Dynamic> = new Map<String, Dynamic>();

  public var isPlayer:Bool = false;
  public var curCharacter:String = DEFAULT_CHARACTER;

  public var holdTimer:Float = 0;
  public var heyTimer:Float = 0;
  public var specialAnim:Bool = false;
  public var animationNotes:Array<Dynamic> = [];
  public var stunned:Bool = false;
  // public var singTimer:Float = CharacterFile.singTime; // Multiplier of how long a character holds the sing pose
  public var singTimer:Float = 8.0; // Multiplier of how long a character holds the sing pose
  public var idleSuffix:String = '';
  public var danceIdle:Bool = false; // Character use "danceLeft" and "danceRight" instead of "idle"
  public var skipDance:Bool = false;

  public var healthIconId:String = 'face';
  public var animationsData:Array<AnimationData> = [];

  public var positionArray:Array<Float> = [0, 0];
  public var cameraPosition:Array<Float> = [0, 0];

  // public var healthColorArray:Array<Int> = [255, 0, 0];
  public var missingCharacter:Bool = false;
  public var missingText:FlxText;
  public var hasMissAnimations:Bool = false;
  public var vocalsFile:String = '';

  // Used on Character Editor
  public var imageFile:String = '';
  public var jsonScale:Float = 1;
  public var noAntialiasing:Bool = false;
  public var originalFlipX:Bool = false;
  public var editorIsPlayer:Null<Bool> = null;

  public function new(x:Float = 0, y:Float = 0, ?character:String = 'bf', ?isPlayer:Bool = false)
  {
    super(x, y);
    animation = new AnimController(this);
    animOffsets = new Map<String, Array<Dynamic>>();
    this.isPlayer = isPlayer;
    changeCharacter(character);
  }

  public function changeCharacter(character:String)
  {
    animationsData = [];
    animOffsets = [];
    curCharacter = character;
    var characterPath:String = 'data/characters/$character.json';

    var path:String = Paths.getPath(characterPath, TEXT, 'shared');
    /*
      #if MODS_ALLOWED
      if (!FileSystem.exists(path))
      #else
      if (!Assets.exists(path))
      #end
     */
    if (!Assets.exists(path))
    {
      path = Paths.getSharedPath('data/characters/' + DEFAULT_CHARACTER +
        '.json'); // If a character couldn't be found, change him to BF just to prevent a crash
      missingCharacter = true;
      missingText = new FlxText(0, 0, 300, 'ERROR:\n$character.json', 16);
      missingText.alignment = CENTER;
    }

    try
    {
      loadCharacterFile(Json.parse(Assets.getText(path)));
    }
    catch (e:Dynamic)
    {
      trace('Error loading character file of "$character": $e');
    }

    skipDance = false;
    // hasMissAnimations = hasAnimation('singLEFTmiss') || hasAnimation('singDOWNmiss') || hasAnimation('singUPmiss') || hasAnimation('singRIGHTmiss');
    recalculateDanceIdle();
    dance();
  }

  public function loadCharacterFile(json:Dynamic)
  {
    isAnimateAtlas = false;

    scale.set(1, 1);
    updateHitbox();

    if (!isAnimateAtlas)
    {
      frames = Paths.getMultiAtlas(json.image.split(','), "shared");
    }
    imageFile = json.image;
    jsonScale = json.scale;
    if (json.scale != 1)
    {
      scale.set(jsonScale, jsonScale);
      updateHitbox();
    }

    // positioning
    positionArray = json.offsets;
    cameraPosition = json.cameraOffsets;

    // data
    healthIconId = json.healthicon.id;
    singTimer = json.singTimer;
    flipX = (json.flipX != isPlayer);
    // healthColorArray = (json.healthbar_colors != null && json.healthbar_colors.length > 2) ? json.healthbar_colors : [161, 161, 161];
    // vocalsFile = json.vocals_file != null ? json.vocals_file : '';
    originalFlipX = (json.flipX == true);
    editorIsPlayer = json._editor_isPlayer;

    // antialiasing
    noAntialiasing = (json.no_antialiasing == true);
    // antialiasing = ClientPrefs.data.antialiasing ? !noAntialiasing : false;

    // animations
    animationsData = json.animations;
    if (animationsData != null && animationsData.length > 0)
    {
      for (anim in animationsData)
      {
        var animName:String = '' + anim.name;
        var animPrefix:String = '' + anim.prefix;
        var animFps:Int = anim.fps;
        var animLoop:Bool = !!anim.looped; // Bruh
        var animIndices:Array<Int> = anim.indices;
        if (!isAnimateAtlas)
        {
          if (animIndices != null && animIndices.length > 0) animation.addByIndices(animName, animPrefix, animIndices, "", animFps, animLoop);
          else
            animation.addByPrefix(animName, animPrefix, animFps, animLoop);
        }

        if (anim.offsets != null && anim.offsets.length > 1) addOffset(anim.name, anim.offsets[0], anim.offsets[1]);
        else
          addOffset(anim.name, 0, 0);
      }
    }
    // trace('Loaded file to character ' + curCharacter);
  }

  override function update(elapsed:Float)
  {
    // if (isAnimateAtlas) atlas.update(elapsed);

    if (debugMode || (!isAnimateAtlas && animation.curAnim == null))
    {
      super.update(elapsed);
      return;
    }

    if (heyTimer > 0)
    {
      // var rate:Float = (PlayState.instance != null ? PlayState.instance.playbackRate : 1.0);
      var rate:Float = 1;
      heyTimer -= elapsed * rate;
      if (heyTimer <= 0)
      {
        var anim:String = getAnimationName();
        if (specialAnim && (anim == 'hey' || anim == 'cheer'))
        {
          specialAnim = false;
          dance();
        }
        heyTimer = 0;
      }
    }
    else if (specialAnim && isAnimationFinished())
    {
      specialAnim = false;
      dance();
    }
    else if (getAnimationName().endsWith('miss') && isAnimationFinished())
    {
      dance();
      finishAnimation();
    }

    if (getAnimationName().startsWith('sing')) holdTimer += elapsed;
    else if (isPlayer) holdTimer = 0;

    // if (!isPlayer
    // && holdTimer >= Conductor.stepCrochet * (0.0011 #if FLX_PITCH / (FlxG.sound.music != null ? FlxG.sound.music.pitch : 1) #end) * singTimer)
    if (!isPlayer
      && holdTimer >= ((60 / 150) * 1000) / 4 * (0.0011 #if FLX_PITCH / (FlxG.sound.music != null ? FlxG.sound.music.pitch : 1) #end) * singTimer)
    {
      dance();
      holdTimer = 0;
    }

    var name:String = getAnimationName();
    if (isAnimationFinished() && hasAnimation('$name-loop')) playAnim('$name-loop');

    super.update(elapsed);
  }

  /*
    inline public function isAnimationNull():Bool
    {
      return !isAnimateAtlas?animation.curAnim == null;
  }*/
  inline public function isAnimationNull():Bool
  {
    return animation.curAnim == null;
  }

  var _lastPlayedAnimation:String;

  inline public function getAnimationName():String
  {
    return _lastPlayedAnimation;
  }

  public function isAnimationFinished():Bool
  {
    if (isAnimationNull()) return false;
    return animation.curAnim.finished;
  }

  public function finishAnimation():Void
  {
    if (isAnimationNull()) return;

    if (!isAnimateAtlas) animation.curAnim.finish();
  }

  public function hasAnimation(anim:String):Bool
  {
    return animOffsets.exists(anim);
  }

  public var animPaused(get, set):Bool;

  private function get_animPaused():Bool
  {
    if (isAnimationNull()) return false;
    return animation.curAnim.paused;
  }

  private function set_animPaused(value:Bool):Bool
  {
    if (isAnimationNull()) return value;
    if (!isAnimateAtlas) animation.curAnim.paused = value;

    return value;
  }

  public var danced:Bool = false;

  /**
   * FOR GF DANCING SHIT
   */
  public function dance()
  {
    if (!debugMode && !skipDance && !specialAnim)
    {
      if (danceIdle)
      {
        danced = !danced;

        if (danced) playAnim('danceRight' + idleSuffix);
        else
          playAnim('danceLeft' + idleSuffix);
      }
      else if (hasAnimation('idle' + idleSuffix)) playAnim('idle' + idleSuffix);
    }
  }

  public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
  {
    specialAnim = false;
    if (!isAnimateAtlas)
    {
      animation.play(AnimName, Force, Reversed, Frame);
    }
    /*
      else
      {
        atlas.anim.play(AnimName, Force, Reversed, Frame);
        atlas.update(0);
    }*/
    _lastPlayedAnimation = AnimName;

    if (hasAnimation(AnimName))
    {
      var daOffset = animOffsets.get(AnimName);
      offset.set(daOffset[0], daOffset[1]);
    }
    // else offset.set(0, 0);

    if (curCharacter.startsWith('gf-') || curCharacter == 'gf')
    {
      if (AnimName == 'singLEFT') danced = true;
      else if (AnimName == 'singRIGHT') danced = false;

      if (AnimName == 'singUP' || AnimName == 'singDOWN') danced = !danced;
    }
  }

  function loadMappedAnims():Void
  {
    /*
      try
      {
        var songData:SwagSong = Song.getChart('picospeaker', Paths.formatToSongPath(Song.loadedSongName));
        if (songData != null) for (section in songData.notes)
          for (songNotes in section.sectionNotes)
            animationNotes.push(songNotes);

        TankmenBG.animationNotes = animationNotes;
        animationNotes.sort(sortAnims);
      }
      catch (e:Dynamic) {}
     */
  }

  function sortAnims(Obj1:Array<Dynamic>, Obj2:Array<Dynamic>):Int
  {
    return FlxSort.byValues(FlxSort.ASCENDING, Obj1[0], Obj2[0]);
  }

  public var danceEveryNumBeats:Int = 2;

  private var settingCharacterUp:Bool = true;

  public function recalculateDanceIdle()
  {
    var lastDanceIdle:Bool = danceIdle;
    danceIdle = (hasAnimation('danceLeft' + idleSuffix) && hasAnimation('danceRight' + idleSuffix));

    if (settingCharacterUp)
    {
      danceEveryNumBeats = (danceIdle ? 1 : 2);
    }
    else if (lastDanceIdle != danceIdle)
    {
      var calc:Float = danceEveryNumBeats;
      if (danceIdle) calc /= 2;
      else
        calc *= 2;

      danceEveryNumBeats = Math.round(Math.max(calc, 1));
    }
    settingCharacterUp = false;
  }

  public function addOffset(name:String, x:Float = 0, y:Float = 0)
  {
    animOffsets[name] = [x, y];
  }

  public function quickAnimAdd(name:String, anim:String)
  {
    animation.addByPrefix(name, anim, 24, false);
  }

  // Atlas support
  // special thanks ne_eo for the references, you're the goat!!
  @:allow(states.editors.CharacterEditorState)
  public var isAnimateAtlas(default, null):Bool = false;
  /*
    #if flxanimate
    public var atlas:FlxAnimate;

    public override function draw()
    {
      var lastAlpha:Float = alpha;
      var lastColor:FlxColor = color;
      if (missingCharacter)
      {
        alpha *= 0.6;
        color = FlxColor.BLACK;
      }

      if (isAnimateAtlas)
      {
        if (atlas.anim.curInstance != null)
        {
          copyAtlasValues();
          atlas.draw();
          alpha = lastAlpha;
          color = lastColor;
          if (missingCharacter && visible)
          {
            missingText.x = getMidpoint().x - 150;
            missingText.y = getMidpoint().y - 10;
            missingText.draw();
          }
        }
        return;
      }
      super.draw();
      if (missingCharacter && visible)
      {
        alpha = lastAlpha;
        color = lastColor;
        missingText.x = getMidpoint().x - 150;
        missingText.y = getMidpoint().y - 10;
        missingText.draw();
      }
    }

    public function copyAtlasValues()
    {
      @:privateAccess
      {
        atlas.cameras = cameras;
        atlas.scrollFactor = scrollFactor;
        atlas.scale = scale;
        atlas.offset = offset;
        atlas.origin = origin;
        atlas.x = x;
        atlas.y = y;
        atlas.angle = angle;
        atlas.alpha = alpha;
        atlas.visible = visible;
        atlas.flipX = flipX;
        atlas.flipY = flipY;
        atlas.shader = shader;
        atlas.antialiasing = antialiasing;
        atlas.colorTransform = colorTransform;
        atlas.color = color;
      }
    }

    public override function destroy()
    {
      atlas = FlxDestroyUtil.destroy(atlas);
      super.destroy();
    }
    #end
   */
}
