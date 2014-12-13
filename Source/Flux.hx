
import com.tenderowls.txml176.*;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.TypeTools;
import haxe.xml.Fast;
import promhx.PublicStream;
import promhx.Stream;

class Flux {

    macro public static function compose<T,U>(template:ExprOf<String>){
        if (template == null) return macro null;
        var exprs = switch(template.expr){
            case EConst(CString(c)) :{
                var tx    = Xml176Parser.parse(c);
                var xml   = tx.document.firstElement();
                bindTemplate(tx, xml);
            }
            case _ : throw("Flux template must be a literal string expression");
        }
        return exprs;
    }


#if macro
    public static function bindTemplate(tx:com.tenderowls.txml176.Xml176Document, xml:Xml) : Expr {
        var exprs = new Array<Expr>();
        var links = new Array<Expr>();

        for (a in xml.attributes()){
            var expr = tx.getAttributeTemplate(xml, a);
            if (expr != null){
                var m_expr =
                    Context.parseInlineString( expr, Context.currentPos());

                var link_expr = switch(m_expr.expr){
                    case EConst(CIdent(s)) :  macro {
                        promhx.base.AsyncBase.link(
                                $m_expr,
                                o.stream.$a,
                                function(x) return x
                                );
                    }
                    case  EConst(_) : macro o.stream.$a.resolve($m_expr);
                    default : null;
                };
                links.push(link_expr);
            }
        }
        var body_exprs = new Array<Expr>();
        for (c in xml){
            switch(c.nodeType){
                case 'element' : body_exprs.push(Flux.bindTemplate(tx, c));
                default : null;
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
        return macro {
            var o = new $typepath();
            $b{links}
            $b{body_exprs}
            o;
        };

    }

#end

}



