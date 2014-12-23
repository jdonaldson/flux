package flux;
import flash.display.DisplayObject;
import promhx.base.AsyncBase;
class Pool<T> implements IFlux extends flash.display.Sprite {
    @stream var arr : Array<T>;
    var num_body_children = 0;
    var createBody : TemplateStream<T>->Array<DisplayObject>;
    var bodies: Array<TemplateStream<T>>= [];
    
    public function new(createBody : TemplateStream<T>->Array<DisplayObject>) {
        super();
        this.createBody = createBody;
        stream.arr.then(function(arr){
            var i = 0;
            while (i < arr.length){ // iterate through new data
                if (i < bodies.length){ // if data exists and body exists
                    bodies[i].resolve(arr[i]); // update it.
                } else if (i >= bodies.length){ //  else if we're missing body
                    var tvar = new TemplateStream<T>(); // create it
                    tvar.resolve(arr[i]);
                    var body = createBody(tvar);
                    num_body_children = body.length;
                    for (b in body) this.addChild(b);
                }
                i++;
            }
            if (i < bodies.length-1){
                // if we have too many children, remove them.
                var start =  i * num_body_children;
                var end = bodies.length * num_body_children;

                for (c in start...end){
                    bodies[i].unlink(untyped this.getChildAt(c));
                }
                this.removeChildren(i * num_body_children, bodies.length * num_body_children);
            }


        });
    }
}
