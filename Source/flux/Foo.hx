
package flux;
import promhx.Stream;
class Foo implements IFlux extends flash.display.Shape{
    public var _flux_id : String;
    public var _flux_class : String;
    public var _flux_keys : String;
    public var _flux_stash : String;
    public function new() {
        super();
        props = {x : new Stream<Int>()};
    }
    public var props (default, null ) : {
        x : Stream<Int>
    };
    public dynamic function _flux_compare(o1:Dynamic, o2:Dynamic){};
}
