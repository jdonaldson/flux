
#if macro
    static function streamify(f:Field){
        var set_expr : Expr = null;
        var tpath: ComplexType = null;

        var set_expr = switch(f.kind){
            case FVar(t,e) : {
                tpath = t;
            }
            default : null;
        }

        // var stream = FVar(TPath({
        //     name   : 'Stream',
        //     pack   : [],
        //     params : [TPType(tpath)]
        // }), set_expr);

        // f.kind = stream;
        // return f;
    }
#end

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
