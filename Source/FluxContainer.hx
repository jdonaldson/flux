import flash.display.DisplayObjectContainer;
import flash.display.DisplayObject;
import promhx.Stream;
import flash.display.Sprite;

class FluxContainer<T> extends Sprite implements IFlux{
    public var _flux_id : String;
    public var _flux_class : String;
    public var _flux_compare : IFlux->Void;
    public var state(default,null):T;
    public function new(state:T) {
        super();
        this.state = state;
    }
}
