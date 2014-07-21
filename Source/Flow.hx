#if !macro
import flash.display.DisplayObjectContainer;
#end

import haxe.macro.Context;
import promhx.Stream;
import haxe.macro.Expr;
import promhx.PublicStream;
import haxe.xml.Fast;

class Flow {

    macro public static function on(ostate : ExprOf<Dynamic<Dynamic>>, xml: String){
        
        var exprs:Array<Expr> = [];
        var state = streamify(ostate);
        var fx = new Fast(Xml.parse(xml));
        var elements = [for (n in fx.elements) {node : n, rootname: 'fc'}];
        var counter = 0;
        while (elements.length > 0){
            var elt = elements.shift();
            var pack = elt.node.name.split('.'); 
            var name = pack.pop();
            var typepath = {
                params : [],
                pack : pack,
                name : name
            }

            var setexprs:Array<Expr> = [];
            for (att in elt.node.x.attributes()){
                if (~/^:/.match(att)){
                    // link mode
                    var attname = att.substring(1);
                    setexprs.push(macro {
                        $i{'fc$counter'}.state.$attname.then(function(x){
                            o.$attname = untyped x;
                        });
                    });
                } else if (~/^\./.match(att)){
                    // literal mode
                    var attname = att.substring(1);
                    var val = Context.parseInlineString(elt.node.x.get(att), Context.currentPos());
                    setexprs.push(macro o.$attname = $val); 
                } else {
                    // string mode
                    var name = elt.node.x.get(att);
                    setexprs.push(macro o.$att = $v{name} );
                }
            }

            for (c in elt.node.elements){
                elements.push({node: c, rootname : 'fc$counter++'});
            }

            exprs.push( macro {
                 var o = new $typepath();
                 $b{setexprs};
                 $i{'fc$counter'}.addChild(o);
            });
        }
        var children = {expr:EArrayDecl(exprs), pos:Context.currentPos()};
        // var children = {expr:EArrayDecl([]), pos:Context.currentPos()};
        return $b{ macro {
            var fc0 = new FlowContainer($state);
            $b{exprs};
            fc0;
        }}; 

        return macro $b{exprs};

    }

    /**
      Converts a simple anonymous object (or reference to one) to an anonymous
      object containing stream versions of the original field values.
     **/
#if macro
     public static function streamify(arg:ExprOf<Dynamic<Dynamic>>){
        var expr = 
            switch(arg.expr){
                case EObjectDecl(fields) : {
                    EObjectDecl(fields.map(function(x){
                        var expr = x.expr;

                        return {
                            field : x.field,
                            expr : macro promhx.PublicStream.publicstream($expr)
                        }
                    }));
                }
                case EConst(c): {
                    switch(Context.typeof(arg)){
                        case TAnonymous(a) : {
                            EObjectDecl(a.get().fields.map(function(x){ 
                                var name = x.name;
                                return {
                                    field : name, 
                                    expr : macro promhx.PublicStream.publicstream($arg.$name) 
                                };
                            }));
                        }
                        case _ : {
                            EObjectDecl([]);
                        };
                    }
                }
                case _ : {
                    EObjectDecl([]);
                }
            }
        return {expr:expr, pos : Context.currentPos()};
    }
#end
}

