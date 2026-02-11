package funkin.backend.song;

import thx.semver.Version;
import thx.semver.VersionRule;

@:nullSafety
class SongRegistry
{
  public static final SONG_METADATA_VERSION:Version = "1.0.0";
  public static final SONG_CHART_DATA_VERSION:Version = "1.0.0";

  public static final SONG_METADATA_VERSION_RULE:Version = "1.0.X";
  public static final SONG_CHART_DATA_VERSION_RULE:Version = "1.0.X";

  public static var DEFAULT_GENERATEDBY(get, never):String;
}
