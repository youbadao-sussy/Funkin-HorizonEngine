package source.funkin.ui.debug;

import flixel.FlxSubState;

/**
 * Debug Menu State
 */
class MasterEditorMenu extends FlxSubState
{
  var options:Array<String> = [
    #if MODS_ALLOWED 'Mods Menu', #end
    'Chart Editor',
    'Character Editor',
    'Stage Editor',
    'Week Editor',
    'Menu Character Editor',
    'Dialogue Editor',
    'Dialogue Portrait Editor',
    'Note Splash Editor',
    'Test Editor'
  ];
  private var grpTexts:FlxTypedGroup<Alphabet>;
  private var directories:Array<String> = [null];

  private var curSelected = 0;
  private var curDirectory = 0;
  private var directoryTxt:FlxText;
}
