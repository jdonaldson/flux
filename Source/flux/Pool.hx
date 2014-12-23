package flux;
import flash.display.DisplayObject;
class Pool<T> implements IFlux extends flash.display.Sprite {
    @stream var arr : Array<T>;
    var num_body_children = 0;
    var createBody : Void->Array<DisplayObject>;
    
    public function new(createBody : Void->Array<DisplayObject>) {
        super();
        this.createBody = createBody;
        stream.arr.then(function(arr){
            trace(arr);
        });
    }
}
