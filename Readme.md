#Flux#

Flux is a little experiment for a macro-driven reactive binding between  a
simple xml template scheme and a generic graphics library.

For now, it works on single nodes (see the demo Main.hx for more details):

```haxe
Flux.on({x:100, y:1}, " <flash.text.TextField text='hello world' :x='x' .y='4'/> ");
```

In this example, we create a model from an anonymous object.  The ```Flux.on```
method accepts this model as a first argument.  It then accepts a template
argument that refers to one or more (one for now) class references. For now,
any class that extends flash.display.DisplayObject will work.

Fields for a class receive their arguments via attributes.  Flux doesn't handle 
class constructors with arguments.

If the field is a simple static text field, you can set it directly.  E.g.,
in the example above I set the "text" field to "hello world".

Since xml attributes must be quoted text, Flux provides a way to specify other
constant values via a dot (.) prefix.  If the attribute has a dot before it, the
text will be evaluated as a constant expression by the haxe macro system.

Finally, if the field is prefixed by a colon (:), Flux will attempt to bind the
given field to a model variable using the promhx.Stream library.

```Flux.on``` returns a modified version of its model argument.  Each field
specified in the model has been mapped to a promhx.Stream equivalent.  These 
fields can then be updated to dynamically change the template parameters they
are attached to.

