import flash.display.DisplayObjectContainer;
import haxe.ds.Vector;
import flash.display.DisplayObject;
class FluxUtils {
    public static function recycle(obj:DisplayObjectContainer) : Iterator<DisplayObject> {
        [for idx in 0...obj.numChildren obj.getChildAt(idx)] 


    }
}
