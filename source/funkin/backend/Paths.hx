package funkin.backend;

import animate.FlxAnimateFrames;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame.FlxFrameAngle;
import flixel.math.FlxRect;
import flixel.system.FlxAssets;
import flixel.graphics.FlxGraphic;
// import funkin.graphics.FunkinSprite.AtlasSpriteSettings;
import funkin.util.macro.ConsoleMacro;
import haxe.io.Path;
import haxe.xml.Access;
import haxe.Json;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
import openfl.system.System;
import openfl.display.BitmapData;
import lime.utils.Assets;
import flash.media.Sound;

/**
 * A core class which handles determining asset paths.
 */
// @:nullSafety

@:access(openfl.display.BitmapData)
class Paths implements ConsoleClass
{
  inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;
  inline public static var VIDEO_EXT = "mp4";

  static var currentLevel:Null<String> = null;
  public static var localTrackedAssets:Array<String> = [];
  public static var currentTrackedSounds:Map<String, Sound> = [];
  public static var dumpExclusions:Array<String> = ['assets/shared/music/freakyMenu.$SOUND_EXT'];

  // haya I love you for the base cache dump I took to the max
  public static function clearUnusedMemory()
  {
    // clear non local assets in the tracked assets list
    for (key in currentTrackedAssets.keys())
    {
      // if it is not currently contained within the used local assets
      if (!localTrackedAssets.contains(key) && !dumpExclusions.contains(key))
      {
        destroyGraphic(currentTrackedAssets.get(key)); // get rid of the graphic
        currentTrackedAssets.remove(key); // and remove the key from local cache map
      }
    }

    // run the garbage collector for good measure lmfao
    System.gc();
  }

  @:access(flixel.system.frontEnds.BitmapFrontEnd._cache)
  public static function clearStoredMemory()
  {
    // clear anything not in the tracked assets list
    for (key in FlxG.bitmap._cache.keys())
    {
      if (!currentTrackedAssets.exists(key)) destroyGraphic(FlxG.bitmap.get(key));
    }

    // clear all sounds that are cached
    for (key => asset in currentTrackedSounds)
    {
      if (!localTrackedAssets.contains(key) && !dumpExclusions.contains(key) && asset != null)
      {
        Assets.cache.clear(key);
        currentTrackedSounds.remove(key);
      }
    }
    // flags everything to be cleared out next unused memory clear
    localTrackedAssets = [];
    // #if !html5 openfl.Assets.cache.clear("songs"); #end
  }

  inline static function destroyGraphic(graphic:FlxGraphic)
  {
    // free some gpu memory
    if (graphic != null && graphic.bitmap != null && graphic.bitmap.__texture != null) graphic.bitmap.__texture.dispose();
    FlxG.bitmap.remove(graphic);
  }

  static public function setCurrentLevel(name:String)
    currentLevel = name.toLowerCase();

  public static function stripLibrary(path:String):String
  {
    var parts:Array<String> = path.split(':');
    if (parts.length < 2) return path;
    return parts[1];
  }

  public static function getLibrary(path:String):String
  {
    var parts:Array<String> = path.split(':');
    if (parts.length < 2) return 'preload';
    return parts[0];
  }

  public static function getPath(file:String, type:AssetType, ?library:String):String
  {
    if (library != null) return getFolderPath(file, library);

    if (currentLevel != null && currentLevel != 'shared')
    {
      var levelPath = getFolderPath(file, currentLevel);
      if (OpenFlAssets.exists(levelPath, type)) return levelPath;
    }
    return getSharedPath(file);
  }

  public static function getLibraryPath(file:String, library = 'preload'):String
  {
    return if (library == 'preload' || library == 'default') getPreloadPath(file); else getLibraryPathForce(file, library);
  }

  static inline function getLibraryPathForce(file:String, library:String):String
  {
    return '$library:assets/$library/$file';
  }

  static inline function getPreloadPath(file:String):String
  {
    return 'assets/$file';
  }

  inline static public function getFolderPath(file:String, folder = "shared")
    return 'assets/$folder/$file';

  inline public static function getSharedPath(file:String = '')
    return 'assets/shared/$file';

  public static function file(file:String, type:AssetType = TEXT, ?library:String):String
  {
    return getPath(file, type, library);
  }

  public static function animateAtlas(path:String, ?library:String):String
  {
    return getLibraryPath('images/$path', library);
  }

  public static function txt(key:String, ?library:String):String
  {
    return getPath('data/$key.txt', TEXT, library);
  }

  public static function frag(key:String, ?library:String):String
  {
    return getPath('shaders/$key.frag', TEXT, library);
  }

  public static function vert(key:String, ?library:String):String
  {
    return getPath('shaders/$key.vert', TEXT, library);
  }

  public static function xml(key:String, ?library:String):String
  {
    return getPath('data/$key.xml', TEXT, library);
  }

  public static function json(key:String, ?library:String):String
  {
    return getPath('data/$key.json', TEXT, library);
  }

  public static function srt(key:String, ?library:String, ?directory:String = "data/"):String
  {
    return getPath('$directory$key.srt', TEXT, library);
  }

  /*
    public static function sound(key:String, ?library:String):String
    {
      return getPath('sounds/$key.${Constants.EXT_SOUND}', SOUND, library);
    }

    public static function soundRandom(key:String, min:Int, max:Int, ?library:String):String
    {
      return sound(key + FlxG.random.int(min, max), library);
    }

    public static function music(key:String, ?library:String):String
    {
      return getPath('music/$key.${Constants.EXT_SOUND}', MUSIC, library);
  }*/
  /*
    public static function videos(key:String, ?library:String):String
    {
      final path:Path = new Path(key);
      final lib:String = library ?? 'videos';

      if (path.ext != null)
      {
        return getPath('videos/${path.file}.${path.ext}', BINARY, lib);
      }

      return getPath('videos/$key.${Constants.EXT_VIDEO}', BINARY, lib);
    }
   */ /*
    public static function voices(song:String, ?suffix:String = ''):String
    {
      if (suffix == null) suffix = ''; // no suffix, for a sorta backwards compatibility with older-ish voice files

      return 'songs:assets/songs/${song.toLowerCase()}/Voices$suffix.${Constants.EXT_SOUND}';
  }*/
  /**
   * Gets the path to an `Inst.mp3/ogg` song instrumental from songs:assets/songs/`song`/
   * @param song name of the song to get instrumental for
   * @param suffix any suffix to add to end of song name, used for `-erect` variants usually
   * @param withExtension if it should return with the audio file extension `.mp3` or `.ogg`.
   * @return String
   */ /*
    public static function inst(song:String, ?suffix:String = '', withExtension:Bool = true):String
    {
      var ext:String = withExtension ? '.${Constants.EXT_SOUND}' : '';
      return 'songs:assets/songs/${song.toLowerCase()}/Inst$suffix$ext';
    }
   */
  public static var currentTrackedAssets:Map<String, FlxGraphic> = [];

  inline static public function image(key:String, ?library:String):FlxGraphic
  {
    // streamlined the assets process more
    key = 'images/$key.png';
    var bitmap:BitmapData = null;
    if (currentTrackedAssets.exists(key))
    {
      localTrackedAssets.push(key);
      return currentTrackedAssets.get(key);
    }
    return cacheBitmap(key, library, bitmap);
  }

  // public static function cacheBitmap(key:String, ?library:String = null, ?bitmap:BitmapData, ?allowGPU:Bool = true):FlxGraphic

  public static function cacheBitmap(key:String, ?library:String = null, ?bitmap:BitmapData, ?allowGPU:Bool = true):FlxGraphic
  {
    if (bitmap == null)
    {
      var file:String = getPath(key, IMAGE, library);
      /*
        #if MODS_ALLOWED if (FileSystem.exists(file)) bitmap = BitmapData.fromFile(file);
        else #end */
      if (OpenFlAssets.exists(file, IMAGE)) bitmap = OpenFlAssets.getBitmapData(file);

      if (bitmap == null)
      {
        trace('Bitmap not found: $file | key: $key');
        return null;
      }
    }

    // if (allowGPU && ClientPrefs.data.cacheOnGPU && bitmap.image != null)
    if (bitmap.image != null)
    {
      bitmap.lock();
      if (bitmap.__texture == null)
      {
        bitmap.image.premultiplied = true;
        bitmap.getTexture(FlxG.stage.context3D);
      }
      bitmap.getSurface();
      bitmap.disposeImage();
      bitmap.image.data = null;
      bitmap.image = null;
      bitmap.readable = true;
    }

    var graph:FlxGraphic = FlxGraphic.fromBitmapData(bitmap, false, key);
    graph.persist = true;
    graph.destroyOnNoUse = false;

    currentTrackedAssets.set(key, graph);
    localTrackedAssets.push(key);
    return graph;
  }

  public static function font(key:String):String
  {
    return 'assets/fonts/$key';
  }

  public static function ui(key:String, ?library:String):String
  {
    return xml('ui/$key', library);
  }

  static public function getAtlas(key:String, ?library:String = null):FlxAtlasFrames
  {
    var useMod = false;
    var imageLoaded:FlxGraphic = image(key, library);

    var myXml:Dynamic = getPath('images/$key.xml', TEXT, library);
    if (OpenFlAssets.exists(myXml) #if MODS_ALLOWED || (FileSystem.exists(myXml) && (useMod = true)) #end)
    {
      /*
        #if MODS_ALLOWED
        return FlxAtlasFrames.fromSparrow(imageLoaded, (useMod ? File.getContent(myXml) : myXml));
        #else
        return FlxAtlasFrames.fromSparrow(imageLoaded, myXml);
        #end */
    }
    else
    {
      var myJson:Dynamic = getPath('images/$key.json', TEXT, library);
      if (OpenFlAssets.exists(myJson) /* #if MODS_ALLOWED || (FileSystem.exists(myJson) && (useMod = true)) #end*/)
      {
        /*
          #if MODS_ALLOWED
          return FlxAtlasFrames.fromTexturePackerJson(imageLoaded, (useMod ? File.getContent(myJson) : myJson));
          #else
          return FlxAtlasFrames.fromTexturePackerJson(imageLoaded, myJson);
          #end */
      }
    }
    return getPackerAtlas(key, library);
  }

  inline static public function getSparrowAtlas(key:String, ?library:String):FlxAtlasFrames
  {
    var imageLoaded:FlxGraphic = image(key, library);
    return FlxAtlasFrames.fromSparrow(imageLoaded, file('images/$key.xml', library));
  }

  static public function getMultiAtlas(keys:Array<String>, ?library:String = null):FlxAtlasFrames
  {
    var parentFrames:FlxAtlasFrames = Paths.getAtlas(keys[0].trim(), library);
    if (keys.length > 1)
    {
      var original:FlxAtlasFrames = parentFrames;
      parentFrames = new FlxAtlasFrames(parentFrames.parent);
      parentFrames.addAtlas(original, true);
      for (i in 1...keys.length)
      {
        var extraFrames:FlxAtlasFrames = Paths.getAtlas(keys[i].trim(), library);
        if (extraFrames != null) parentFrames.addAtlas(extraFrames, true);
      }
    }
    return parentFrames;
  }

  /*
    public static function getAnimateAtlas(key:String, ?library:String, settings:AtlasSpriteSettings):FlxAnimateFrames
    {
      var assetLibrary:String = library ?? "";
      var graphicKey:String = "";

      if (assetLibrary != "")
      {
        graphicKey = Paths.animateAtlas(key, assetLibrary);
      }
      else
      {
        graphicKey = Paths.animateAtlas(key);
      }

      var validatedSettings:AtlasSpriteSettings =
        {
          swfMode: settings?.swfMode ?? false,
          cacheOnLoad: settings?.cacheOnLoad ?? false,
          filterQuality: settings?.filterQuality ?? MEDIUM,
          spritemaps: settings?.spritemaps ?? null,
          metadataJson: settings?.metadataJson ?? null,
          cacheKey: settings?.cacheKey ?? null,
          uniqueInCache: settings?.uniqueInCache ?? false,
          onSymbolCreate: settings?.onSymbolCreate ?? null,
          applyStageMatrix: settings?.applyStageMatrix ?? false,
          useRenderTexture: settings?.useRenderTexture ?? false
        };

      // Validate asset path.
      if (!Assets.exists('${graphicKey}/Animation.json'))
      {
        throw 'No Animation.json file exists at the specified path (${graphicKey})';
      }

      return FlxAnimateFrames.fromAnimate(graphicKey, validatedSettings.spritemaps, validatedSettings.metadataJson, validatedSettings.cacheKey,
        validatedSettings.uniqueInCache, {
          swfMode: validatedSettings.swfMode,
          cacheOnLoad: validatedSettings.cacheOnLoad,
          filterQuality: validatedSettings.filterQuality,
          onSymbolCreate: validatedSettings.onSymbolCreate
        });
    }
   */
  public static function getPackerAtlas(key:String, ?library:String):FlxAtlasFrames
  {
    return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
  }
}

enum abstract PathsFunction(String)
{
  var MUSIC;
  var INST;
  var VOICES;
  var SOUND;
}
