import flash.display.DisplayObjectContainer;
import flash.display.DisplayObject;
import promhx.Stream;
import flash.display.Sprite;

class FlowContainer<T> extends Sprite{
    public var state(default,null):T;
    public function new(state:T) {
        super();
        this.state = state;
    }
}


