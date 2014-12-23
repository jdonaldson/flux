
import com.tenderowls.txml176.*;
import haxe.Template;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.TypeTools;
import haxe.xml.Fast;
import promhx.PublicStream;
import promhx.Stream;

class Flux {

    macro public static function compose<T, U>(template : ExprOf<String>){
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
    public static function bindTemplate(tx : Xml176Document, xml : Xml): Expr {
        var exprs = new Array<Expr>();
        var attr_links = new Array<Expr>();

        for (a in xml.attributes()){
            var expr = tx.getAttributeTemplate(xml, a);
            if (expr != null){
                var m_expr =
                    Context.parseInlineString( expr, Context.currentPos());

                var link_expr = switch(m_expr.expr){
                    case EConst(CIdent(s)) :  {
                        // var cur_type = Context.typeof(m_expr);
                        // var async_type = Context.typeof(macro new TemplateStream<Dynamic>());
                        macro { 
                            o.templateBindings.push({from : $m_expr, to: o.stream.$a});
                        }
                    }
                    case EConst(_), EArrayDecl(_) : macro  {
                        o.stream.$a.setDefaultState($m_expr);
                    }
                    default : null;
                };
                if (link_expr != null) attr_links.push(link_expr);
            }
        }

        var body_exprs = new Array<Expr>();

        for (c in xml){
            switch(c.nodeType){
                case 'element' : body_exprs.push(Flux.bindTemplate(tx, c));
                default : null;
            }
        }

        var root = xml;
        var pack = root.nodeName.split('.');
        var name = pack.pop();
        var typepath = {
            params : [],
            pack : pack,
            name : name
        }

        if (typepath.name != "pool"){
            return macro {
                var o = new $typepath();
                $b{attr_links} 
                for (a in $a{body_exprs}) o.addChild(a); 
                o;
            };

        } else {
            return macro {
                var o = new flux.Pool(function() return $a{body_exprs});
                $b{attr_links}
                o;
            }
        }
        

    }
#end


}

