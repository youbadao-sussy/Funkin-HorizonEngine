package source.funkin.backend.loading;

/**
 * Loading Json Data
 */
class LoadingData
{
  public var version:String;
  public var timing:String;
  public var loadingImage:Bool = false;
  @:optional @:default("Images") public var imageType:String;
  public var assetFilePath:String = "loading";
  public var loadingScreen:Array<LoadingScreenData>;
}

class LoadingScreenData
{
  public var assetPath:Array<String>;
  public var transIn:Array<TransInData>;
  public var transOut:Array<TransOutData>;
  public var data:String;
}

class TransInData
{
  public var type:String = "Original";
  public var color:String = "Black";
  public var direction:String = "N";
  public var duration:Float = 0.5;
}

class TransInData
{
  public var type:String = "Original";
  public var color:String = "Black";
  public var direction:String = "S";
  public var duration:Float = 0.5;
}
