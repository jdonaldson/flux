
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
                linkXmlTemplateAttributes(tx, xml);
            }
            case _ : throw("Flux template must be a literal string expression");
        }
        return macro $b{exprs};
    }


#if macro
    public static function linkXmlTemplateAttributes(tx:com.tenderowls.txml176.Xml176Document, xml:Xml){

        var exprs = new Array<Expr>();
        var links = new Array<Expr>();

        for (a in xml.attributes()){
            var expr = tx.getAttributeTemplate(xml, a);
            if (expr != null){
                var m_expr = Context.parseInlineString(
                        expr, 
                        Context.currentPos());

                links.push(switch(m_expr.expr){
                    case EConst(CIdent(s)) :  macro {
                        var idf = function(x) return x;
                        promhx.base.AsyncBase.link( $m_expr, o.stream.$a, idf);
                    }
                    case  EConst(_) : macro o.stream.$a.resolve($m_expr);
                    default : null;
                });

            }
        }
        for (c in xml){
            trace(c);
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
        return exprs;
    }



    inline public static function identity<T>(x:T) return x;
#end



}


