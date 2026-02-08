#if !macro
// Discord API
// Psych
#if sys
import sys.*;
import sys.io.*;
#elseif js
import js.html.*;
#end
// Flixel
import flixel.sound.FlxSound;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.debug.watch.Tracker;
// flixel
import flixel.input.keyboard.FlxKey;
// Funkin
import funkin.backend.Paths;
import funkin.backend.save.SettingSaveData;
import funkin.Assets;
import funkin.states.PlayState;
import funkin.states.InitState;
// Haxe
import haxe.ds.Option;
// OpenFL
import openfl.display.BitmapData;

using Lambda;
using StringTools;
using funkin.util.AnsiUtil;
using funkin.util.tools.ArraySortTools;
using funkin.util.tools.ArrayTools;
using funkin.util.tools.FloatTools;
using funkin.util.tools.Int64Tools;
using funkin.util.tools.IntTools;
using funkin.util.tools.IteratorTools;
using funkin.util.tools.StringTools;
using thx.Arrays;

/*
  import funkin.backend.Language; */
#end
// Imports used only in macros
