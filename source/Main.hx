package;

import lime.system.System;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.input.keyboard.FlxKey;
import flixel.FlxState;
import openfl.display.Sprite;
// import funkin.ui.input.Cursor;
#if hxvlc
import hxvlc.util.Handle;
#end
import openfl.display.Sprite;
import openfl.display.StageScaleMode;
import openfl.events.Event;
import openfl.Lib;
import openfl.media.Video;
import openfl.net.NetStream;
#if !macro
import funkin.states.PlayState;
import funkin.states.InitState;
#end

using funkin.util.AnsiUtil;

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

    var game:FlxGame = new FlxGame(gameWidth, gameHeight, initialState, framerate, framerate, skipSplash, (FlxG.stage.window.fullscreen));
    addChild(game);
    // Lib.current.stage.align = "tl";
    // Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
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
}
