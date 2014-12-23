import promhx.PublicStream;
class TemplateStream<T> extends PublicStream<T>{
    var _defaultState:T;
    public function new() super(); 
    public function setDefaultState(v:T) {
        _defaultState = v;
        if (!this.isResolved()) _val = v; 
    }
    public function reset() handleResolve(_defaultState);
}
