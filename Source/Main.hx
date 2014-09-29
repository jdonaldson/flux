package;


import flash.display.Sprite;
import Flux;
import promhx.Stream;
import flux.Foo;


class Main extends Sprite {
	public function new () {
		super ();
		var foob = Flux.on(
		        {x:100, y:1, z:[1,2,3], s:'hi'}, 
                {k : [1,2,3]},
		        "<flux.text.TextField text='helloworld' :x='x' .y='4'/>"
		        );
		var t = new haxe.Timer(20);
		var count = 0;
		t.run = function(){
		    foob.props.x.resolve(count);
		    count+=1;
        }
		flash.Lib.current.addChild(foob);
	}
}
