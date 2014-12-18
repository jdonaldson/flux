package flux;
import flash.display.DisplayObject;
class Pool<T> implements IFlux extends flash.display.Sprite {
    @stream var arr : Array<T>;
    var num_body_children = 0;
    
    public function new(createBody : Void->Array<DisplayObject>) {
        super();
        stream.arr.then(function(arr){
            trace(arr);
        });
    }
    public dynamic function createBody() : Array<DisplayObject> return null; 
}
