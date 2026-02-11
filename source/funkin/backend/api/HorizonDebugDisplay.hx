package funkin.backend.api;

import states.editors.MasterEditorMenu;
import flixel.FlxG;
import lime.math.Rectangle;
import openfl.display.Sprite;
import openfl.events.KeyboardEvent;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.Lib;

/**
 * FPS Display Yee
 */
class HorizonFPS
{
  /**
   * The current frame rate, expressed using frames-per-second
   */
  public var currentFPS(default, null):Int;

  // The current memory usage (WARNING: this is NOT your total program memory usage, rather it shows the garbage collector memory)
  public var memoryMegas(get, never):Float;
  public var maxMemoryMegas:Float; // Max memory

  @:noCompletion private var times:Array<Float>;

  public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
  {
    super();

    this.x = x;
    this.y = y;

    backgroundColor = 0xFF000000;
    currentFPS = 0;
    selectable = true;
    mouseEnabled = true;
    defaultTextFormat = new TextFormat("_sans", 14, color);
    autoSize = LEFT;
    multiline = true;
    text = "FPS: ";

    times = [];

    if (FlxG.save.data.displayDebugType != null) curDisplay = FlxG.save.data.displayDebugType;
  }

  var deltaTimeout:Float = 0.0;

  // Event Handlers
  private override function __enterFrame(deltaTime:Float):Void
  {
    final now:Float = haxe.Timer.stamp() * 1000;
    times.push(now);
    while (times[0] < now - 1000)
      times.shift();
    // prevents the overlay from updating every frame, why would you need to anyways @crowplexus
    if (deltaTimeout < 50)
    {
      deltaTimeout += deltaTime;
      return;
    }

    currentFPS = times.length < FlxG.updateFramerate ? times.length : FlxG.updateFramerate;
    updateText();
    deltaTimeout = 0.0;

    if (FlxG.mouse.x >= x && FlxG.mouse.x <= x + width && FlxG.mouse.y >= y && FlxG.mouse.y <= y + height) alpha = 1;
    else
      alpha = 0.5;
  }

  public static var curDisplay:Int = 0;

  public dynamic function updateText():Void
  {
    // so people can override it in hscript
    switch (curDisplay)
    {
      case 0:
        @:privateAccess
        {
          text = 'FPS: ${currentFPS}'
            + '\nMemory: ${flixel.util.FlxStringUtil.formatBytes(memoryMegas)} / ${flixel.util.FlxStringUtil.formatBytes(maxMemoryMegas)}'
            + '\n'
            + '\nState: ${Type.getClassName(Type.getClass(FlxG.state))}'
            + '\nObjects: ${FlxG.state.members.length}';
          background = true;
        }
      case 1:
        text = 'FPS: ${currentFPS}'
          + '\nMemory: ${flixel.util.FlxStringUtil.formatBytes(memoryMegas)} / ${flixel.util.FlxStringUtil.formatBytes(maxMemoryMegas)}';
        background = true;
      case 2:
        text = '';
        background = false;
    }

    textColor = 0xFFFFFFFF;
    if (currentFPS < FlxG.drawFramerate * 0.5) textColor = 0xFFFF0000;

    if (memoryMegas > maxMemoryMegas) maxMemoryMegas = memoryMegas;
  }

  inline function get_memoryMegas():Float
    return cpp.vm.Gc.memInfo64(cpp.vm.Gc.MEM_INFO_USAGE);
}

/**
 * Main Yee
 */
class HorizonDebugDisplay {}
