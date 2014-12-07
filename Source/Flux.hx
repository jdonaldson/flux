#if !macro
import flash.display.DisplayObjectContainer;
#end

import haxe.macro.Context;
import promhx.Stream;
import haxe.macro.Expr;
import promhx.PublicStream;
import haxe.xml.Fast;
import com.tenderowls.xml176.*;

class Flux {

    macro public static function compose<T,U>(template:ExprOf<String>){
        
        var exprs:Array<Expr> = [];
        if (template != null){
            switch(template.expr){
                case EConst(CString(c)) : {
                    var tx = com.tenderowls.txml176.Xml176Parser.parse(c);
                    var xml = tx.document.firstElement();

                    var links : Array<Expr> = [];
                    for (a in xml.attributes()){
                        var expr = tx.getAttributeTemplate(xml, a);
                        if (expr != null){
                            var m_expr = Context.parseInlineString(expr, Context.currentPos());
                            links.push(macro o.stream.$a.resolve(${m_expr}));
                        }
                    }
                    var root = tx.document.firstElement();
                    var pack = root.nodeName.split('.');
                    var name = pack.pop();
                    var typepath = {
                        params : [],
                        pack : pack,
                        name : name
                    }
                    exprs.push( macro { 
                        var o = new $typepath(); 
                        $b{links}
                        o;
                    });


                };
                case _ : null;
            }

        }
        return macro $b{exprs};
    }


    macro static function on2(oprops : ExprOf<Dynamic<Dynamic>>, ostate : ExprOf <Dynamic<Dynamic>>, xml: String){
        
        var exprs:Array<Expr> = [];
        var props = streamify(oprops);
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
            var compexprs : Array<Expr> = []; 
            var atts = elt.node.x.attributes();
            for (att in atts){
                var valname = elt.node.x.get(att);
                if (~/^:/.match(att)){
                    // link mode
                    var attname = att.substring(1);
                    setexprs.push(macro {
                        $i{'fc$counter'}.props.$valname.then(function(x){
                            o.$attname = untyped x;
                        });
                    });
                    compexprs.push(macro o1.$attname = o2.$attname);
                } else if (~/^\./.match(att)){
                    // literal mode
                    var attname = att.substring(1);
                    var val = Context.parseInlineString(elt.node.x.get(att), Context.currentPos());
                    setexprs.push(macro o.$attname = $val); 
                    compexprs.push(macro o1.$attname = o2.$attname);
                } else {
                    // string mode
                    var name = elt.node.x.get(att);
                    setexprs.push(macro o.$att = $v{name} );
                    compexprs.push(macro o1.$att = o2.$att);
                }
            }
            var compfunc = macro {
                 o._flux_compare = function(o1, o2){
                    $b{compexprs};
                }
            }
            setexprs.push(compfunc);

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

        return $b{ macro {
            var fc0 = new FluxContainer($props);
            fc0._flux_render = function(){
                $b{exprs};
            }
            fc0._flux_render();
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
                                    expr  : macro promhx.PublicStream.publicstream($arg.$name)
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


