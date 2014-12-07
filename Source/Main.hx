package;


import flash.display.Sprite;
import Flux;
import promhx.Stream;
import flux.Foo;


class Main extends Sprite {
	public function new () {
		super ();
		trace('hi');

		return;
		var s = new Stream<Int>();

		var k = new FluxContainer();

		var t = new haxe.Timer(20);
		var count = 0;

        var f = Flux.compose("

                <FluxContainer text={'ho'}/>
                
                ");

		t.run = function(){
		    var cnt = count++;
		    k.stream.x.resolve(cnt);
		    f.stream.x.resolve(cnt+10);
        }
        flash.Lib.current.addChild(k);
        flash.Lib.current.addChild(f);
	}

	public function new2 () {
	    var i = new promhx.PublicStream<String>();
	 	// var foob = Flux.compose(
		        // "
		            // <flux.text.TextField text={i}/>
                // "
		        // );
	 	// var foob = Flux.compose(
		        // "
		        // <pool for={i in 0..4}>
		            // <flux.text.TextField text={i}/>
                // </pool>
                // "
		        // );
		// var t = new haxe.Timer(20);
		// var count = 0;
		// t.run = function(){
		//     foob.props.x.resolve(count);
		//     count+=1;
        // }
		// flash.Lib.current.addChild(foob);
	}
}

