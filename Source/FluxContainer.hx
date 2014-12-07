import flash.display.DisplayObjectContainer;
import flash.display.DisplayObject;
import flash.display.Sprite;
import promhx.Stream;

class FluxContainer implements IFlux extends flash.text.TextField {
    @stream var x    : Int    = 4;
    @stream var text : String = 'hi';

    public function new() {
        super(); 
        stream.x.then(function(x){ this.x = x; });
        stream.text.then(function(x){ this.text = x; }); 
    }
}

