package;

import lime.system.System;
import lime.app.Application;
import flixel.graphics.FlxGraphic;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.input.keyboard.FlxKey;
import flixel.FlxState;
#if sys
import sys.FileSystem;
import sys.io.File;
#elseif js
import js.html.FileSystem;
#end
import openfl.display.Sprite;
// import funkin.ui.input.Cursor;
#if hxvlc
import hxvlc.util.Handle;
#end
import haxe.io.Path;
import openfl.display.Sprite;
import openfl.display.StageScaleMode;
import openfl.events.Event;
import openfl.Lib;
import openfl.media.Video;
import openfl.net.NetStream;
#if !macro
import funkin.backend.save.SettingSaveData;
import funkin.backend.playing.Controls;
import funkin.states.PlayState;
import funkin.states.InitState;
// import funkin.states.MainMenuState;
// import funkin.backend.api.HorizonDebugDisplay;
#end
// crash handler stuff
#if CRASH_HANDLER
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;
import sys.io.Process;
#end

using funkin.util.AnsiUtil;
using StringTools;

/**
 * The main class which initializes HaxeFlixel and starts the game in its initial state.
 */
class Main extends Sprite
{
  var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).

  var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
  var initialState:Class<FlxState> = PlayState; // The FlxState the game starts with.
  var framerate:Int = 60; // The target framerate of the game.
  var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
  var skipSplash:Bool = false; // Whether to skip the flixel splash screen that appears in release mode.

  public static function main():Void
  {
    // We need to make the crash handler LITERALLY FIRST so nothing EVER gets past it.
    // CrashHandler.initialize();
    // CrashHandler.queryStatus();

    Lib.current.addChild(new Main());
  }

  public function new()
  {
    super();

    // Get OpenFL to stop complaining so much.
    // You can remove this line if you want to read debug messages.
    openfl.utils._internal.Log.level = openfl.utils._internal.Log.LogLevel.INFO;

    init();
  }

  function init(?event:Event):Void
  {
    setupGame();
  }

  function setupGame():Void
  {
    initHaxeUI();
    // George recommends binding the save before FlxGame is created.
    // Save.load();

    #if hxvlc
    // Initialize hxvlc's Handle here so the videos are loading faster.
    Handle.initAsync(function(success:Bool):Void {
      if (success)
      {
        trace(' HXVLC '.bold().bg_orange() + ' LibVLC instance initialized!');
      }
      else
      {
        trace(' HXVLC '.bold().bg_orange() + ' LibVLC instance failed to initialize!');
      }
    });
    #end

    Controls.instance = new Controls();
    SettingSaveData.loadDefaultKeys();
    var game:FlxGame = new FlxGame(gameWidth, gameHeight, initialState, framerate, framerate, skipSplash, (FlxG.stage.window.fullscreen));
    addChild(game);
    Lib.current.stage.align = "tl";
    Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
    #if html5
    FlxG.autoPause = false;
    FlxG.mouse.visible = false;
    #end

    FlxG.fixedTimestep = false;
    FlxG.game.focusLostFramerate = 60;
    FlxG.keys.preventDefaultKeys = [TAB];
    #if CRASH_HANDLER
    Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
    #end
    // shader coords fix
    FlxG.signals.gameResized.add(function(w, h) {
      if (FlxG.cameras != null)
      {
        for (cam in FlxG.cameras.list)
        {
          if (cam != null && cam.filters != null) resetSpriteCache(cam.flashSprite);
        }
      }

      if (FlxG.game != null) resetSpriteCache(FlxG.game);
    });
  }

  static function resetSpriteCache(sprite:Sprite):Void
  {
    @:privateAccess {
      sprite.__cacheBitmap = null;
      sprite.__cacheBitmapData = null;
    }
  }

  function initHaxeUI():Void
  {
    // This has to come before Toolkit.init since locales get initialized there
    haxe.ui.locale.LocaleManager.instance.autoSetLocale = false;
    // Calling this before any HaxeUI components get used is important:
    // - It initializes the theme styles.
    // - It scans the class path and registers any HaxeUI components.
    haxe.ui.Toolkit.init();
    haxe.ui.Toolkit.theme = 'dark'; // don't be cringe
    // haxe.ui.Toolkit.theme = 'light'; // embrace cringe
    haxe.ui.Toolkit.autoScale = false;
    // Don't focus on UI elements when they first appear.
    haxe.ui.focus.FocusManager.instance.autoFocus = false;
    funkin.ui.input.Cursor.registerHaxeUICursors();
    haxe.ui.tooltips.ToolTipManager.defaultDelay = 200;
  }

  // Code was entirely made by sqirra-rng for their fnf engine named "Izzy Engine", big props to them!!!
  // very cool person for real they don't get enough credit for their work
  #if CRASH_HANDLER
  function onCrash(e:UncaughtErrorEvent):Void
  {
    var errMsg:String = "";
    var path:String;
    var callStack:Array<StackItem> = CallStack.exceptionStack(true);
    var dateNow:String = Date.now().toString();

    dateNow = dateNow.replace(" ", "_");
    dateNow = dateNow.replace(":", "'");

    path = "./crash/" + "PsychEngine_" + dateNow + ".txt";

    for (stackItem in callStack)
    {
      switch (stackItem)
      {
        case FilePos(s, file, line, column):
          errMsg += file + " (line " + line + ")\n";
        default:
          Sys.println(stackItem);
      }
    }

    errMsg += "\nUncaught Error: " + e.error;
    // remove if you're modding and want the crash log message to contain the link
    // please remember to actually modify the link for the github page to report the issues to.
    #if officialBuild
    errMsg += "\nPlease report this error to the GitHub page: https://github.com/youbadao-sussy/Funkin-HorizonEngine";
    #end
    errMsg += "\n\n> Crash Handler written by: sqirra-rng for Psych Engine";

    if (!FileSystem.exists("./crash/")) FileSystem.createDirectory("./crash/");

    File.saveContent(path, errMsg + "\n");

    Sys.println(errMsg);
    Sys.println("Crash dump saved in " + Path.normalize(path));

    Application.current.window.alert(errMsg, "Error!");
    /*
      #if DISCORD_ALLOWED
      DiscordClient.shutdown();
      #end
     */
    Sys.exit(1);
  }
  #end
}
