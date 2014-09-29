import flash.display.DisplayObjectContainer;
import flash.display.DisplayObject;
import promhx.Stream;
import flash.display.Sprite;
import FluxUtils;

class FluxContainer<T,U> extends Sprite implements IFlux{
    public var _flux_id : String;
    public var _flux_class : String;
    public var _flux_keys    : Map<String, IFlux>;
    public var _flux_stash   : Array<IFlux>;
    public var props(default,null):T;
    var state:U;
    public function new(?props:T) {
        super();
        this.props = props;
        _flux_keys = new Map();
    }
    public function retrieveChild(type:Class<IFlux>, ?key:String){
        // if (key != null){
        //     return _flux_keys.get(key);
        // } else {
            
        // }
    }
    public function stashChildren(){
        for (c in 0...this.numChildren) _flux_stash.push(cast this.removeChildAt(0)); 
    }
    public dynamic function _flux_set_state(state:U){}
    public dynamic function _flux_compare<T>(o1:T, o2:T){}
    public dynamic function _flux_render(){}
}

