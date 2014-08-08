package flux.text;
class TextField extends flash.text.TextField implements IFlux{
    public var _flux_id : String;
    public var _flux_class : String;
    public var _flux_compare : Dynamic->Dynamic->Void;
    public function new() super();
}
