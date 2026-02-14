package funkin.ui;

import flixel.FlxState;
import funkin.backend.camera.FunkinCamera;

class MusicBeatState
{
  private var curSection:Int = 0;
  private var stepsToDo:Int = 0;

  private var curStep:Int = 0;
  private var curBeat:Int = 0;

  private var curDecStep:Float = 0;
  private var curDecBeat:Float = 0;

  public var controls(get, never):Controls;

  private function get_controls()
  {
    return Controls.instance;
  }

  var _funkinCameraInitialized:Bool = false;

  public var variables:Map<String, Dynamic> = new Map<String, Dynamic>();

  public static function getVariables()
    return getState().variables;

  override function create()
  {
    var skip:Bool = FlxTransitionableState.skipNextTransOut;
    #if MODS_ALLOWED Mods.updatedOnState = false; #end

    if (!_funkinCameraInitialized) initFunkinCamera();

    super.create();

    if (!skip)
    {
      openSubState(new CustomFadeTransition(0.5, true));
    }
    FlxTransitionableState.skipNextTransOut = false;
    timePassedOnState = 0;
  }

  public function initFunkinCamera():FunkinCamera
  {
    var camera = new FunkinCamera();
    FlxG.cameras.reset(camera);
    FlxG.cameras.setDefaultDrawTarget(camera, true);
    _funkinCameraInitialized = true;
    // trace('initialized funkin camera ' + Sys.cpuTime());
    return camera;
  }

  public static function switchState(nextState:FlxState = null)
  {
    if (nextState == null) nextState = FlxG.state;
    if (nextState == FlxG.state)
    {
      resetState();
      return;
    }

    if (FlxTransitionableState.skipNextTransIn) FlxG.switchState(nextState);
    else
      startTransition(nextState);
    FlxTransitionableState.skipNextTransIn = false;
  }

  public static function resetState()
  {
    if (FlxTransitionableState.skipNextTransIn) FlxG.resetState();
    else
      startTransition();
    FlxTransitionableState.skipNextTransIn = false;
  }

  // Custom made Trans in
  public static function startTransition(nextState:FlxState = null)
  {
    if (nextState == null) nextState = FlxG.state;

    FlxG.state.openSubState(new CustomFadeTransition(0.5, false));
    if (nextState == FlxG.state) CustomFadeTransition.finishCallback = function() FlxG.resetState();
    else
      CustomFadeTransition.finishCallback = function() FlxG.switchState(nextState);
  }

  public static function getState():MusicBeatState
  {
    return cast(FlxG.state, MusicBeatState);
  }
}
