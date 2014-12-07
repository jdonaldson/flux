
package flux;
import promhx.Stream;
class Foo<A,B> extends flash.display.Shape{
    public var _flux_id : String;
    public var _flux_class : String;
    public var _flux_keys : String;
    public var _flux_stash : String;
    public var _flux_render : String;
    public var _flux_body : String;
    public function new() {
        super();
        props = {x : new Stream<Int>()};
    }
    public var props (default, null ) : {
        x : Stream<Int>
    };
    public function render(){
    }
    public dynamic function _flux_compare<T>(o1:T, o2:T){};
}
