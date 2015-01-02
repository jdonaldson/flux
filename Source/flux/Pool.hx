package flux;
import flash.display.DisplayObject;
import promhx.base.AsyncBase;
class Pool<T> implements IFlux extends flash.display.Sprite {
    @stream var arr : Array<T>;
    @stream var val : String;
    var createBody : TemplateStream<T>->Array<DisplayObject>;
    var bodies: Array<BodyContent<T>> = [];
    var loadedBodies = 0;

    public function new(createBody : TemplateStream<T>->Array<DisplayObject>) {
        super();
        this.createBody = createBody;
        stream.arr.then(function(arr){
            trace(arr);

            var i = 0;
            while (i < arr.length){ // iterate through new data
                if (i < bodies.length){ // if data exists and body exists
                    bodies[i].stream.resolve(arr[i]); // update it.
                    if (!bodies[i].loaded){
                        for (o in bodies[i].objects) this.addChild(o);
                        bodies[i].loaded = true;
                    }
                } else if (i >= bodies.length){ //  else if we're missing body
                    var tvar = new TemplateStream<T>(); // create it
                    tvar.resolve(arr[i]);
                    var body = createBody(tvar);
                    var objects = [];
                    for (b in body) {
                        this.addChild(b);
                        objects.push(b);
                    }
                    bodies.push({
                        stream: tvar,
                        objects : objects,
                        loaded : true
                    });
                    loadedBodies++;
                }
                i++;
            }
            for (idx in i...loadedBodies){
                for (o in bodies[idx].objects) this.removeChild(o);
                bodies[idx].loaded = false;
            }
            loadedBodies = i;

        });
    }
}

typedef BodyContent<T> = {
    stream: TemplateStream<T>,
    objects: Array<DisplayObject>,
    loaded: Bool
};
