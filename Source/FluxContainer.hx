import flash.display.DisplayObjectContainer;
import flash.text.TextField;
import flash.display.DisplayObject;
import flash.display.Sprite;
import promhx.Stream;

class FluxContainer implements IFlux extends flash.display.Sprite {
    @stream var x     : Int = 4;
    @stream var y     : Int = 0;
    @stream var color : Int = 0x00FF00;
    @stream var text : String = 'hi';
    var tf:TextField;

    public function new() {
        super();
        tf = new TextField();
        tf.text = 'hi';
        tf.y = 5;
        this.addChild(tf);
        stream.x.then(function(x){ this.x = x; tf.text = x + '';  });
        stream.y.then(function(y){ this.y = y; });
        stream.text.then(function(text) tf.text = text);
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
