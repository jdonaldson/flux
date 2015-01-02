package;


import flash.display.Sprite;
import Flux;
import promhx.Stream;
import promhx.PublicStream;
import flux.Foo;


class Main extends Sprite {
	public function new () {
		super ();

		var s = new Stream<Int>();

		// var k = new FluxContainer();
		var t = new haxe.Timer(2000);
		var count = 0;
		var k = Stream.stream(0);
		var l = new PublicStream<Int>();

        var f = Flux.compose("
                <pool val='j' arr={[10,20,30]}>
                    <FluxContainer x={j} y={l} color={0x0000FF}/>
                </pool>
                ");

		t.run = function(){
		    var cnt = count++;
		    var newarr:Array<Int> = [];
		    for (i in 0...Std.random(7)+1){
		        newarr.push(Std.random(100));
		    }
            f.stream.arr.resolve(newarr);
		    l.resolve(cnt);
        }
        flash.Lib.current.addChild(f);
	}

}

