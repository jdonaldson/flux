import promhx.Stream;
class FluxTemplateControl {
    public var templateBindings : Array<FluxBindings> = [];
    public function new(bindings:Array<FluxBindings>) {
        templateBindings = bindings;
    }
    public function pauseStreams()
        for (b in this.templateBindings) b.to.pause(); 

    public function detachStreams() return null;

}
