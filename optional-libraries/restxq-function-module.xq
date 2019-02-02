module namespace rest = "http://exquery.org/ns/restxq";

declare
  %rest:path("/restxq-function-module/resource-functions")
function rest:resource-functions() 
  as document-node(element(rest:resource-functions)) {
  document {
    <rest:resource-functions>{
    for $function in map:get(xdmp:get-server-field("xqrs"), "functions")
    let $function-name as xs:QName := xdmp:function-name($function)
    return
      <rest:resource-function>
        {
          if(xdmp:function-module($function)) then
            attribute xquery-uri {xdmp:function-module($function)}
          else ()
        }
        <rest:identity
          namespace="{namespace-uri-from-QName($function-name)}"
          local-name="{local-name-from-QName($function-name)}"
          arity="{function-arity($function)}" />
      </rest:resource-function>
    }</rest:resource-functions>
  }
};

declare function rest:base-uri() as xs:anyURI {
  xs:anyURI("")
};

declare function rest:uri() as xs:anyURI {
  xs:anyURI("")
};
