package;


import flash.display.Sprite;
import Flux;
import promhx.Stream;
import flux.Foo;


class Main extends Sprite {
	public function new () {
		super ();

		var s = new Stream<Int>();

		var k = new FluxContainer();
		var t = new haxe.Timer(20);
		var count = 0;
		var j = Stream.stream(4);

        var f = Flux.compose("
                <FluxContainer x={j}>
                    <FluxContainer x={12}>
                </FluxContainer>
                ");

		t.run = function(){
		    var cnt = count++;
		    k.stream.x.resolve(cnt);
		    f.stream.x.resolve(cnt+10);
        }
        flash.Lib.current.addChild(k);
        flash.Lib.current.addChild(f);
	}

}

