package funkin.backend.save;

import flixel.util.FlxSave;

@:structInit class SaveVariable
{
  public var downScroll:Bool = false;
  public var middleScroll:Bool = false;
  public var opponentStrums:Bool = true;
  public var showFPS:Bool = true;
  public var flashing:Bool = true;
  public var autoPause:Bool = true;
  public var antialiasing:Bool = true;
  public var noteSkin:String = 'Default';
  public var splashSkin:String = 'Psych';
  public var splashAlpha:Float = 0.6;
  public var lowQuality:Bool = false;
  public var shaders:Bool = true;
  public var cacheOnGPU:Bool = #if ! switch false #else true #end; // GPU Caching made by Raltyro
  public var framerate:Int = 60;
  public var camZooms:Bool = true;
  public var hideHud:Bool = false;
  public var noteOffset:Int = 0;
  public var arrowRGB:Array<Array<FlxColor>> = [
    [0xFFC24B99, 0xFFFFFFFF, 0xFF3C1F56],
    [0xFF00FFFF, 0xFFFFFFFF, 0xFF1542B7],
    [0xFF12FA05, 0xFFFFFFFF, 0xFF0A4447],
    [0xFFF9393F, 0xFFFFFFFF, 0xFF651038]
  ];
  public var arrowRGBPixel:Array<Array<FlxColor>> = [
    [0xFFE276FF, 0xFFFFF9FF, 0xFF60008D],
    [0xFF3DCAFF, 0xFFF4FFFF, 0xFF003060],
    [0xFF71E300, 0xFFF6FFE6, 0xFF003100],
    [0xFFFF884E, 0xFFFFFAF5, 0xFF6C0000]
  ];

  public var ghostTapping:Bool = true;
  public var timeBarType:String = 'Time Left';
  public var scoreZoom:Bool = true;
  public var noReset:Bool = false;
  public var healthBarAlpha:Float = 1;
  public var hitsoundVolume:Float = 0;
  public var pauseMusic:String = 'Tea Time';
  public var checkForUpdates:Bool = true;
  public var comboStacking:Bool = true;
  public var gameplaySettings:Map<String, Dynamic> = [
    'scrollspeed' => 1.0,
    'scrolltype' => 'multiplicative',
    // anyone reading this, amod is multiplicative speed mod, cmod is constant speed mod, and xmod is bpm based speed mod.
    // an amod example would be chartSpeed * multiplier
    // cmod would just be constantSpeed = chartSpeed
    // and xmod basically works by basing the speed on the bpm.
    // iirc (beatsPerSecond * (conductorToNoteDifference / 1000)) * noteSize (110 or something like that depending on it, prolly just use note.height)
    // bps is calculated by bpm / 60
    // oh yeah and you'd have to actually convert the difference to seconds which I already do, because this is based on beats and stuff. but it should work
    // just fine. but I wont implement it because I don't know how you handle sustains and other stuff like that.
    // oh yeah when you calculate the bps divide it by the songSpeed or rate because it wont scroll correctly when speeds exist.
    // -kade
    'songspeed' => 1.0,
    'healthgain' => 1.0,
    'healthloss' => 1.0,
    'instakill' => false,
    'practice' => false,
    'botplay' => false,
    'opponentplay' => false
  ];

  public var comboOffset:Array<Int> = [0, 0, 0, 0];
  public var ratingOffset:Int = 0;
  public var sickWindow:Float = 45.0;
  public var goodWindow:Float = 90.0;
  public var badWindow:Float = 135.0;
  public var safeFrames:Float = 10.0;
  public var guitarHeroSustains:Bool = true;
  public var discordRPC:Bool = true;
  public var loadingScreen:Bool = true;
  public var language:String = 'en-US';
}

class SettingSaveData
{
  public static var appName:String = "Funkin' Horizon Engine";
  public static var appVersion:String = "0.2.7";
}
