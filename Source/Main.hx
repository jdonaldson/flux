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

		var t = new haxe.Timer(10);
		var count = 0;
		var l = new PublicStream<Int>();

        var f = Flux.compose("
                <pool val='j' arr={[10,20,30]}>
                    <FluxContainer x={j} y={l} color={0x0000FF}/>
                </pool>
                ");

		t.run = function(){
		    var cnt = count++;
		    var newarr:Array<Int> = [];
		    for (i in 0...Std.random(100)+1){
		        newarr.push(Std.random(1000));
		    }
            f.stream.arr.resolve(newarr);
		    l.resolve(cnt);
        }
        flash.Lib.current.addChild(f);
	}

}

