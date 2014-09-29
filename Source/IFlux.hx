interface IFlux {
    public var _flux_id      : String;
    public var _flux_class   : String;
    public dynamic function _flux_compare<T>(o1:T, o2:T) : Void;
}
