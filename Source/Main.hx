package;


import flash.display.Sprite;
import Flux;
import promhx.Stream;
import flux.Foo;


class Main extends Sprite {
	public function new () {
		super ();

		var s = new Stream<Int>();

		// var k = new FluxContainer();
		var t = new haxe.Timer(20);
		var count = 0;
		var j = Stream.stream(4);

        // var f = Flux.compose("
        //         <FluxContainer x={j} color={0xFF0000}>
        //             <FluxContainer x={12} color={0x0000FF}>
        //         </FluxContainer>
        //         ");

        var f = Flux.compose("
                <pool val='j' arr={[1,2,3]}>
                    <FluxContainer x={j} color={0x0000FF}/>
                </pool>
                ");

		// t.run = function(){
		//     var cnt = count++;
		//     k.stream.x.resolve(cnt);
		//     f.stream.x.resolve(cnt+10);
        // }
        // flash.Lib.current.addChild(f);
	}

}

