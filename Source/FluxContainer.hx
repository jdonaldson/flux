import flash.display.DisplayObjectContainer;
import flash.display.DisplayObject;
import flash.display.Sprite;
import promhx.Stream;

class FluxContainer implements IFlux extends flash.display.Sprite {
    @stream var x     : Int = 4;
    @stream var y     : Int = 0;
    @stream var color : Int = 0x00FF00;

    public function new() {
        super(); 
        var tf = new flash.text.TextField();
        tf.text = 'hi';
        tf.y = 5;
        this.addChild(tf);
        stream.x.then(function(x){ this.x = x; });
        stream.y.then(function(y){ this.y = y; });
        stream.color.then(function(color) { 
            this.graphics.clear();
            this.graphics.beginFill(color);
            this.graphics.drawRect(0,0,10,10);
        });
    }
}

// class FluxContainer implements IFlux extends flash.text.TextField {
//     @stream var x    : Int    = 4;
//     @stream var text : String = 'hi';

//     public function new() {
//         super(); 
//         stream.x.then(function(x){ this.x = x; });
//         stream.text.then(function(x){ this.text = x; }); 
//     }
// }
