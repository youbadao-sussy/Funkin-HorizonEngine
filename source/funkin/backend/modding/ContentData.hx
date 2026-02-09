package source.funkin.backend.modding;

/**
 * It is Contents(mods) Data!
 */
class ContentData
{
  public var title:String = "Unknown Mod";
  public var author:String = "Unknown";
  public var description:String = "No description provided.";
  public var homepage:String = "No website provided.";
  public var contributors:ContentContributors;
  @:optional public var dependencies:Array<String> = [];
  public var api_version:String = "0.0.1";
  public var mod_version:String = "1.0.0";
  public var iconPath:String;
  public var license:String = "Apache-2.0";
}

class ContentContributors
{
  public var name:String = "Unknown Creator";
  @:optional public var about:String;
  @:optional public var role:String;
  @:optional public var email:String;
  @:optional public var url:String;
}
