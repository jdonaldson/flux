package flux;
class Iteration<T> implements IFlux extends flash.display.Shape {
    public var _flux_id : String;
    public var _flux_class : String;
    public var _flux_compare : IFlux->Void;
    public var items  : Array<T>; 
    public var item  : T;
    public function new()  super();
}
