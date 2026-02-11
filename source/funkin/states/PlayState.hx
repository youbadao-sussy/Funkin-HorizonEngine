package funkin.states;

import funkin.objects.*;
import flixel.FlxObject;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.utils.Assets as OpenFlAssets;
import openfl.events.KeyboardEvent;
#if !flash
import openfl.filters.ShaderFilter;
#end

/**
 * It is Gameplay State!
 */
class PlayState extends FlxState
{
  public var opponentMap:Map<String, Character> = new Map<String, Character>();
  public var centerMap:Map<String, Character> = new Map<String, Character>();
  public var playerMap:Map<String, Character> = new Map<String, Character>();
  public var opponent:Character = null;
  public var center:Character = null;
  public var player:Character = null;
  public var opponentGroup:FlxSpriteGroup;
  public var centerGroup:FlxSpriteGroup;
  public var playerGroup:FlxSpriteGroup;
  public var PLY_X:Float = 770;
  public var PLY_Y:Float = 100;
  public var OPP_X:Float = 100;
  public var OPP_Y:Float = 100;
  public var CEN_X:Float = 400;
  public var CEN_Y:Float = 130;
  public var playerCameraOffset:Array<Float> = null;
  public var opponentCameraOffset:Array<Float> = null;
  public var centerCameraOffset:Array<Float> = null;

  // Camera
  public var camFollow:FlxObject;
  public var defaultCamZoom:Float = 1.00;

  // Stage
  public static var curStage:String = '';

  // public var playbackRate(default, set):Float = 1;
  public static var instance:PlayState;

  // public static var SONG:SwagSong = null;
  public static var nextReloadAll:Bool = false;

  /**
   * create function
   */
  override public function create()
  {
    super.create();

    Paths.clearStoredMemory();
    /*
      if (nextReloadAll)
      {
        Paths.clearUnusedMemory();
      }
      nextReloadAll = false;
     */

    var text = new FlxText(10, 10, 100, "Hello World");
    add(text);
    // for lua
    instance = this;

    // playerCameraOffset = stageData.camera_player;
    if (playerCameraOffset == null) // Fucks sake should have done it since the start :rolling_eyes:
      playerCameraOffset = [0, 0];

    // centerCameraOffset = stageData.camera_center;
    if (centerCameraOffset == null) // Fucks sake should have done it since the start :rolling_eyes:
      centerCameraOffset = [0, 0];

    playerGroup = new FlxSpriteGroup(PLY_X, PLY_Y);

    player = new Character(0, 0, "bf", true);
    startCharacterPos(player);
    playerGroup.add(player);

    add(playerGroup);

    var camPos:FlxPoint = FlxPoint.get(playerCameraOffset[0], playerCameraOffset[1]);

    camFollow = new FlxObject();
    camFollow.setPosition(camPos.x, camPos.y);
    camPos.put();
    add(camFollow);

    FlxG.camera.follow(camFollow, LOCKON, 0);
    FlxG.camera.zoom = defaultCamZoom;
    FlxG.camera.snapToTarget();

    FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

    /*
      camFollow.x -= player.cameraPosition[0] - playerCameraOffset[0];
      camFollow.y += player.cameraPosition[1] + playerCameraOffset[1];
     */
    /*
      var camPos:FlxPoint = FlxPoint.get(girlfriendCameraOffset[0], girlfriendCameraOffset[1]);
      if (gf != null)
      {
        camPos.x += player.getGraphicMidpoint().x + player.cameraPosition[0];
        camPos.y += player.getGraphicMidpoint().y + player.cameraPosition[1];
      }
     */

    Paths.clearUnusedMemory();
  }

  function startCharacterPos(char:Character, ?gfCheck:Bool = false)
  {
    char.x += char.positionArray[0];
    char.y += char.positionArray[1];
  }

  override public function update(elapsed:Float)
  {
    super.update(elapsed);
  }
}
