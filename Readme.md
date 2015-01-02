#Flux#

Flux is a little experiment for a macro-driven reactive binding between  a
simple xml-ish template scheme and a generic graphics library.

For now, it works on single nodes (see the demo Main.hx for more details):

```haxe
var j = new PublicStream<Int>();
var f = Flux.compose("<flux.FluxContainer x={j} color={0x0000FF}/>");
Lib.current.addChild(f);
j.resolve(4);

```
The compose method takes xml-ish syntax definitions, and changes them into
constructed UI components.  For now, the component objects need to be class
definitions that satisfy two criteria:

1. They must extend a DisplayObject (using OpenFl for now).
2. They must implement the IFlux interface.


The template logic for specifying these classes is fairly simple:
1. The node name must be the fully qualified name of the class (including module
names).
2. The attributes for the xml node must match special member variables (discussed
below)
3. Attribute values may be static declarations (e.g. a color of ```0x0000FF```,
or may be bound to special "Stream" variables.

For this example, we're creating an instance of flux.FluxContainer.  Here's
the first few lines containing member fields:

```haxe
class FluxContainer implements IFlux extends flash.display.Sprite {
    @stream var x     : Int = 4;
    @stream var y     : Int = 0;
    @stream var color : Int = 0x00FF00;
    @stream var text : String = 'hi';
    var tf:TextField;
    [...]
}
```
The Stream variables behave similarly to normal variables:  you can declare
a type, and you can set default values.  However, these variables are not
provided directly on the class instance.  Rather, variables declared in this
fashion appear under a special "stream" field:


``` haxe
class FluxContainer implements IFlux extends flash.display.Sprite {
    @stream var x     : Int = 4;
    [...]

    public function new() {
        super();
        stream.x.then(function(x){ this.x = x;});
    }
}
```

In this way, we've bound the streaming x template variable to the standard "x"
property.


Why use streams?

1. Streams allow for asynchronous resolution of values, which prevents
operations from overloading the ui thread, causing stuttering or jankiness due
to an overloaded cpu.
2. Streams allow easy delegation of errors and flow
control logic.
3. Streams allow for the variables to be read-only within the class itself.
This is a very useful pattern that makes it clear that they should be "owned"
by a parent object.
4. Streams are provided via the [promhx](https://github.com/jdonaldson/promhx)
library, which is a speedy and full featured cross platform promise and
reactive programming language also written by the author.

As mentioned above, components can have parent/child relationships, and their
streaming properties allow them to delegate control over certain variables
to their parent. To specify a parent/child relationship in the components,
simply create a child node in the template, such as one FluxContainer containing
another:



```haxe
var f = Flux.compose("
      <FluxContainer x={j} color={0x0000FF}>
         <FluxContainer x={j} color={0x0000FF}/>
      </FluxContainer>
      ");

```

In this case, the child flux conatiner also becomes a child in the display
object.


Flux also provides a powerful "pool" mechanism, which allows lists of
components to be created from an array:


```haxe
var f = Flux.compose("
      <pool val='j' arr={[10,20,30]}>
         <FluxContainer x={j} y={l} color={0x0000FF}/>
      </pool>
      ");
```

In this example, we are creating a series of FluxContainers based on an array
of three numbers.  Pool will provide the iterator value via its ```val```
attribute name.  You may use this as if it were a normal stream value in any
of the child components.


Pool, as its name implies, implements an object pooling behavior for flux.  This
feature enables constructed components to be reused, which greatly reduces the
time it takes to re-render the components defined by the array.


