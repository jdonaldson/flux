import haxe.ds.Vector;
import haxe.macro.Expr;
import haxe.rtti.Meta;

import haxe.macro.Context;
import promhx.Stream;

class FluxUtils {

    public static function build(cls:Class<Dynamic>){
        var t = Meta.getType(cls);
    }

    macro static public function auto() : Array<haxe.macro.Field>{
        var fields = Context.getBuildFields();
        var adj_fields : Array<Field> = [];
        var stream      : Array<Field> = [];

        var should_init = false;
        for (f in fields ){
            if (f.name == "new"){
                switch(f.kind){
                    case FFun(f) : {
                        switch(f.expr.expr){
                            case EBlock(exprs) : {
                                exprs.unshift(macro this.conflux_init()); 
                            }
                            default : null;
                        }
                    }
                    default : null;
                }
            }
            var skip = false;
            for (m in f.meta){
                switch(m.name){
                    case "stream"  : {
                        stream.push(f);
                        skip = true;
                    }
                }
                if (skip) break;
            }
            if (skip) continue;
            adj_fields.push(f);
        }

        var resets : Array<Expr> = [];
        var constructs : Array<Expr> = [macro stream = untyped {}];
        for (s in stream){
           switch(s.kind){
                case FVar(t,e) : {
                    var name = s.name;
                    var init = macro stream.$name = new promhx.PublicStream();
                    constructs.push(init);
                    if (e != null){
                        var reset = macro stream.$name.resolve(${e});
                        resets.push(reset);
                    }

                    s.kind=
                    FVar(TPath({ 
                        name   : "PublicStream",
                        pack   : ["promhx"],
                        params : [TPType(t)]
                    }));
                }
                default : null;
            }
        }
        if (should_init){
            constructs.push(macro this.conflux_init());
        }

        constructs.push(macro this.reset());


        var construct_block = macro $b{constructs};
        var reset_block = macro $b{resets};

        var conflux_init = {
            name : "conflux_init",
            kind : FFun({
                ret    : null,
                params : [],
                expr   : construct_block ,
                args   : []
            }),
            meta   : [],
            doc    : null,
            pos    : Context.currentPos(),
            access : [APublic]

        }

        var stream_field = {
            name   : "stream",
            kind   : FVar(TAnonymous(stream)),
            meta   : [],
            doc    : null,
            pos    : Context.currentPos(),
            access : [APublic]
        };

        var reset = {
            name : "reset",
            kind : FFun({
                ret    : null,
                params : [],
                expr   : reset_block ,
                args   : []
            }),
            meta   : [],
            doc    : null,
            pos    : Context.currentPos(),
            access : [APublic]
        }

        var flx_id = {
            name   : "_flx_id",
            kind   : FVar(TPath({name:"String", pack:[], params:[]})),
            meta   : [],
            doc    : null,
            pos    : Context.currentPos(),
            access : []
        }

        adj_fields.push(stream_field);
        adj_fields.push(conflux_init);
        adj_fields.push(reset);
        adj_fields.push(flx_id);
        return adj_fields;
    }

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

}
