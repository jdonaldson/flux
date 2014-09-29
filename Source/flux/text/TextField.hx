package flux.text;
class TextField extends flash.text.TextField implements IFlux{
    public var _flux_id : String;
    public var _flux_class : String;
    public function new() super();
    public dynamic function _flux_compare(o1:Dynamic, o2:Dynamic){};
}
